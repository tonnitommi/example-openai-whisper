*** Settings ***
Documentation       Use OpenAI Whisper to convert audio files to text.
Library    RPA.Robocorp.WorkItems
Library    RPA.RobotLogListener
Library    RPA.Robocorp.Vault
Library    RPA.Email.ImapSmtp    smtp_server=smtp.gmail.com    smtp_port=587
Library    String
Library    OperatingSystem
Library    WhisperLibrary


*** Variables ***
# Supported extensions
@{extensions}       mp3    wav
${model_size}       base


*** Tasks ***
Convert audio to text
    [Documentation]
    ...    Get email workitem that triggered the process.
    ...    Read look for supported extensions.
    ...    Trigger file processing.
    For Each Input Work Item    Read files

*** Keywords ***
Read files
    [Documentation]
    ...    What to do here?
    ...    And something....
    ${paths}=    Get Work Item Files    *
    ${payload}=    Get Work Item Payload

    FOR    ${path}    IN    @{paths}

        # Take only file extension
        ${fileext}=    Fetch From Right    ${path}    .

        IF     $fileext.lower() in $extensions
            Log    Working on file ${path}
            Load Model    ${model_size}
            ${result}=    Transcribe    ${path}
            Send Email
            ...    ${payload}[email][from][address]
            ...    ${result}[text]
            ...    ${path}
        ELSE
            Log    Not supported file, ignoring ${path}
        END

    END
    Release Input Work Item    DONE


Send Email
    [Arguments]    ${email}=    ${text}=    ${path}=
    ${filename}=    Fetch From Right    ${path}    /

    ${google}    Get Secret    Google
    Authorize    account=${google}[email]    password=${google}[email-app-password]
    Send Message    sender=${google}[email]
    ...    recipients=${email}
    ...    subject=Whisper for file ${filename}
    ...    body=${text}
