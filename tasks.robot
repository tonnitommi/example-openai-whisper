*** Settings ***
Documentation       Use OpenAI Whisper to convert audio files to text.
Library    RPA.Robocorp.WorkItems
Library    RPA.RobotLogListener
Library    String
Library    OperatingSystem
Library    WhisperLibrary


*** Variables ***
# Supported extensions
@{extensions}       mp3
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

    FOR    ${path}    IN    @{paths}

        # Take only file extension
        ${fileext}=    Fetch From Right    ${path}    .

        IF     $fileext.lower() in $extensions
            Log To Console    Working on file ${path}
            Load Model    ${model_size}
            ${result}=    Transcribe    ${path}
            Log To Console   ${result}[text]
        ELSE
            Log To Console    Ignoring file ${path}
        END

    END
    Release Input Work Item    DONE