*** Settings ***
Documentation     Robot Framework testsuite voor UC14: Inloggen.
...               Gegenereerd om te draaien in een CI/CD pipeline.
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://localhost:5001/api/v1
${LOGIN_PATH}     /auth/login
${VALID_USER}     Eric
${VALID_PW}       Wachtwoord123

*** Test Cases ***

UC14 - MainFlow: Succesvol Inloggen
    [Documentation]    Controleert of een gebruiker met de juiste gegevens toegang krijgt.
    [Tags]    Priority1    SmokeTest
    ${payload}=    Create Dictionary    gebruikersnaam=${VALID_USER}    wachtwoord=${VALID_PW}
    
    # Voer de POST request uit (verify=False negeert SSL-fouten bij lokale dev-certificaten)
    ${response}=    POST    ${BASE_URL}${LOGIN_PATH}    json=${payload}    expected_status=200
    
    # Validatie van de output parameters zoals gedefinieerd in de XML
    Dictionary Should Contain Key    ${response.json()}    gebruikersnaam
    Dictionary Should Contain Key    ${response.json()}    productlijst
    Status Should Be    200    ${response}

UC14 - AF1: Foutieve Gegevens (Fault F1)
    [Documentation]    Controleert of het systeem de juiste melding geeft bij een verkeerd wachtwoord.
    [Tags]    Negative
    ${payload}=    Create Dictionary    gebruikersnaam=${VALID_USER}    wachtwoord=FoutiefWachtwoord
    
    ${response}=    POST    ${BASE_URL}${LOGIN_PATH}    json=${payload}    expected_status=400
    
    # Verifieer de systemResponse uit de XML
    ${message}=    Get From Dictionary    ${response.json()}    message
    Should Be Equal As Strings    ${message}    De combinatie gebruikersnaam en wachtwoord is niet bekend.

UC14 - AF2: Onbekende Gebruiker (Fault F2)
    [Documentation]    Controleert of het systeem vraagt om registratie bij een onbekende gebruiker.
    [Tags]    Negative
    ${payload}=    Create Dictionary    gebruikersnaam=OnbekendeBezoeker    wachtwoord=${VALID_PW}
    
    ${response}=    POST    ${BASE_URL}${LOGIN_PATH}    json=${payload}    expected_status=404
    
    ${message}=    Get From Dictionary    ${response.json()}    message
    Should Be Equal As Strings    ${message}    Gebruiker is niet bekend, registreer u eerst.