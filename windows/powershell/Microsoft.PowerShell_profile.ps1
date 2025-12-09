# -------------------------
# 0. 공용 JumpPaths 변수 정의
# -------------------------
$Global:JumpPaths = @{
    "workspace" = "E:\workspace"
    "stsm" = "E:\workspace\sts-mods"
    "sts" = "D:\Steam\steamapps\common\SlayTheSpire"
}


# -------------------------
# 1. claudeP 함수
# -------------------------
function claudeP {
    claude --dangerously-skip-permissions $args
}


# -------------------------
# 2. jmp 함수
# -------------------------
function jmp {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name
    )

    if ($Global:JumpPaths.ContainsKey($Name)) {
        Set-Location $Global:JumpPaths[$Name]
    } else {
        Write-Error "존재하지 않는 키워드입니다: '$Name'"
        Write-Host "사용 가능한 키워드: $($Global:JumpPaths.Keys -join ', ')" -ForegroundColor Cyan
    }
}


# -------------------------
# 3. 탭 자동완성 등록
# -------------------------
Register-ArgumentCompleter -CommandName jmp -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $Global:JumpPaths.Keys |
        Where-Object { $_ -like "$wordToComplete*" } |
        ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}