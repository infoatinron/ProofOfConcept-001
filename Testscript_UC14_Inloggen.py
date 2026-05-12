import requests
import pytest

BASE_URL = "https://localhost:5001/api/v1"
LOGIN_ENDPOINT = f"{BASE_URL}/auth/login"

def test_uc14_main_flow_success():
    """Valideert de MainFlow: Succesvol inloggen."""
    payload = {
        "gebruikersnaam": "Eric",
        "wachtwoord": "Wachtwoord123"
    }
    
    response = requests.post(LOGIN_ENDPOINT, json=payload, verify=False)
    
    assert response.status_code == 200
    data = response.json()
    assert "gebruikersnaam" in data
    assert "productlijst" in data
    print(f"Test geslaagd: Gebruiker {data['gebruikersnaam']} ingelogd.")

def test_uc14_fault_f1_invalid_credentials():
    """Valideert AF1 / Fault F1: Onjuiste combinatie."""
    payload = {
        "gebruikersnaam": "Eric",
        "wachtwoord": "FoutiefWachtwoord"
    }
    
    response = requests.post(LOGIN_ENDPOINT, json=payload, verify=False)
    
    assert response.status_code == 400
    assert response.json()["message"] == "De combinatie gebruikersnaam en wachtwoord is niet bekend."

def test_uc14_fault_f2_unknown_user():
    """Valideert Fault F2: Onbekende gebruiker."""
    payload = {
        "gebruikersnaam": "OnbekendeBezoeker",
        "wachtwoord": "Wachtwoord123"
    }
    
    response = requests.post(LOGIN_ENDPOINT, json=payload, verify=False)
    
    assert response.status_code == 404
    assert response.json()["message"] == "Gebruiker is niet bekend, registreer u eerst."
