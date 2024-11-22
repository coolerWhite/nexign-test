*** Settings ***
Library           DateTime
Library           RequestsLibrary

*** Variables ***
${URL}        http://worldtimeapi.org/api/timezone/Europe/Moscow
${timeLocal}=    None
${timeMoscow}=    None
${status}=     ${False}
${response}=     None

*** Test Cases ***
GetTimeLocal
    ${timeLocal}=    Get Current Date    result_format=%Y-%m-%d %H:%M
    Log    Local time is: ${timeLocal}

GetTimeMoscow  
    WHILE    $status == ${False}
        TRY
            ${response}=    GET    ${URL}
            Should Be Equal As Strings    ${response.status_code}    200
            Log    Response from ${URL}: ${response}
            ${status}=    Set Variable    ${True}
        EXCEPT    ConnectionError
            Log    Connection failed. Retrying...
        FINALLY
            Sleep    2s
        END
    END
    
    Run Keyword If    ${response} == None    Fail    "Response is not defined, test failed!"


    ${timeMoscowFull}=    Evaluate    ${response.json()}[datetime]
    ${timeMoscow}=    Evaluate    str("${timeMoscowFull}".split('+')[0]).split('.')[0]
    Log    Current time in Moscow: ${timeMoscow}

ComparisonValue
    Should Be Equal As Strings    ${timeMoscow}    ${timeLocal}    "Локальное время не совпадает с временем на удалённом сервере"