*** Settings ***
Library           DateTime
Library           RequestsLibrary

*** Variables ***
${URL}           https://www.timeapi.io/api/Time/current/zone?timeZone=Europe/Moscow
${status}        ${False}

*** Test Cases ***
GetLocalTime
    ${timeLocal}=    Get Current Date    result_format=%Y-%m-%dT%H:%M
    Log    Local time is: ${timeLocal}

    ${response}=    GET    ${URL}
    ${timeMoscow}=    Evaluate    "${response.json()['dateTime']}"[:16]
    Log    Current time in Moscow: ${timeMoscow}

    Run Keyword If    "${timeMoscow}" != "${timeLocal}"    Fail    Локальное время не совпадает с временем на удалённом сервере
    Log    Время совпадает: ${timeMoscow} и ${timeLocal}
