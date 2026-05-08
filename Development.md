Vraagje tussendoor: Ik heb een classlibrary toegevoegd genaamd 'Development'. Ik weet dat via migrations je de database kunt updaten. Welke class/interfaces moet ik daarin ook alweer plaatsen om add en update migrations te verrichten?

Dat is een slimme zet om een aparte Development library te hebben voor je tooling. In een architectuur waar je de DbContext in een aparte library (Data) hebt staan, heeft de EF Core CLI soms een "zetje" nodig om de database te kunnen vinden en de migraties correct te genereren.

De belangrijkste interface die je daarvoor gebruikt is de IDesignTimeDbContextFactory<T>.

Waarom heb je dit nodig?
Wanneer je dotnet ef migrations add uitvoert, probeert de tool je project te draaien om de configuratie te lezen. Omdat je Data project een class library is (en geen uitvoerbaar bestand zoals de API), kan de tool de verbindingsreeks niet vinden. De IDesignTimeDbContextFactory fungeert als een "achterdeur" die EF Core vertelt hoe de DbContext geïnstantieerd moet worden tijdens het ontwerpen.

Wat moet je in de 'Development' library plaatsen?
Je maakt hier een klasse aan (bijvoorbeeld DesignTimeDbContextFactory) die de interface implementeert. Dat ziet er ongeveer zo uit:

C#
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using ProofOfConcept_001.Data; // Je Data namespace

namespace ProofOfConcept_001.Development
{
    public class DesignTimeDbContextFactory : IDesignTimeDbContextFactory<MijnDbContext>
    {
        public MijnDbContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<MijnDbContext>();
            
            // Hardcoded voor development of lees het uit een lokaal bestand
            optionsBuilder.UseSqlServer("Server=(localdb)\\mssqllocaldb;Database=PoC001DB;Trusted_Connection=True;");

            return new MijnDbContext(optionsBuilder.Options);
        }
    }
}
Hoe gebruik je dit voor Migraties?
Wanneer je straks de migraties gaat draaien, moet je de CLI vertellen waar de factory staat en waar de migraties moeten landen. Het commando ziet er dan meestal zo uit:

PowerShell
dotnet ef migrations add InitialCreate `
    --project ProofOfConcept-001.Data `
    --startup-project ProofOfConcept-001.Development `
    --output-dir Migrations
Belangrijke herinnering voor je script:
Omdat je de Development library hiervoor gebruikt, moet je ervoor zorgen dat:

Projectreferentie: De Development library een referentie heeft naar je Data project.

NuGet Package: Je moet het pakket Microsoft.EntityFrameworkCore.Design ook aan het Development project toevoegen (je hebt deze nu alleen in Services staan in je script).

Kortom: De IDesignTimeDbContextFactory<TContext> is de sleutel. Het zorgt ervoor dat je migraties kunt uitvoeren zonder dat je je API-instellingen of omgevingsvariabelen telkens hoeft aan te roepen.

Om je PowerShell-script helemaal waterdicht te maken voor deze workflow, kun je deze twee regels toevoegen aan Stap 4 en Stap 6:

1. Projectreferentie (Stap 4)
Voeg deze regel toe bij de sectie waar je de dependencies regelt:

PowerShell
dotnet add "$projectName.Development" reference "$projectName.Data"
2. NuGet Package (Stap 6)
De factory heeft de Design tools nodig om te kunnen functioneren. Voeg deze toe aan de lijst met packages:

PowerShell
dotnet add "$projectName.Development" package Microsoft.EntityFrameworkCore.Design --version $efVersion
Het volledige plaatje
Zodra je dit hebt gedaan, ziet je architectuur er als volgt uit:

Models: Bevat de blauwdrukken (Entities).

Data: Bevat de DbContext en de fysieke database-configuratie.

Development: Fungeert als de "brug" voor EF Core-gereedschappen, zodat je veilig migraties kunt maken zonder je API-project te hoeven "vervuilen" met hardcoded connection strings.