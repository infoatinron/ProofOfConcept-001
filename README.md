
<b>Software Development Lifecycle (SDLC) met behulp van Gemini AI</b>


**ProofOfConcept-001**<br>
====================<br>
ProofOfConcept-001 is een CSharp solution die met behulp van AI wordt ontwikkeld, dit om in een proof of concept aan te tonen dat gebruik van AI een krachtige co-pilot is die de ontwikkelingssnelheid 10x verhoogt, mits geleid door een sterke software architectuur en menselijke verificatie.

ProofOfConcept-001 is een WebAPI solution met clean architecture, de juiste patterns, interfaces, DTO's en de UnitOfWork. Het use case diagram en de individuele de use cases zetten we in XML om en voeden we aan AI.AI genereert alle classes, interfaces, de logica, de entities en de controller en plaatst ze in de juiste application classlibrary.

**Applicatiestructuur**<br>
=====================<br>
ProofOfConcept-001/<br>
├── ProofOfConcept-001.Api          (Presentation Layer)<br>
├── ProofOfConcept-001.Common       (Shared utilities/types)<br>
├── ProofOfConcept-001.Data         (Infrastructure - Data Access)<br>
├── ProofOfConcept-001.Development  (Dev tools/scripts)<br>
├── ProofOfConcept-001.Models       (Domain Entities/Models)<br>
├── ProofOfConcept-001.Services     (Application/Business Logic)<br>

<b>Aanpak SDLC MVP</b><br>
=====================<br>
1. Opzetten skeleton applicatiestructuur (clean architectuur) met PowerShell;<br>
2. Via bash code pushen naar de master branch in GitHub;<br>
2. Use Case Diagram exporteren naar XML;<br>
3. Individuele use cases schrijven in XML;<br>
4. Gemini genereert hieruit alle interfaces, classes, entities, DTO's. de controller en de UnitOfWork volgens het juiste pattern [1];<br>
5. Gemini genereert de unittests [2];<br>
6. Gemini genereert de functionele tests [3].

<b>Frameworks zoals</b><br>
=====================<br>
[1] ORM-EF, LINQ<br>
[2] N-Unit, X-Unit<br>
[3] Robot Framework
