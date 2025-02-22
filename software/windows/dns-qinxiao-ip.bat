chcp 65001

@echo off
for /f "tokens=2 delims=:" %%f in ('ipconfig ^| findstr /c:"IPv4 Address"^| findstr "192."') do set ip=%%f
set ip=%ip: =%
echo %ip%

@REM https://docs.dnspod.cn/account/dnspod-token/
@REM curl -k https://dnsapi.cn/Domain.List -d "login_token=id,token"
@REM curl -X POST https://dnsapi.cn/Record.List -d "login_token=id,token&format=json&domain_id=66777901&sub_domain=qinxiao&record_type=A"
@REM curl -X POST https://dnsapi.cn/Record.Modify -d "login_token=id,token&format=json&domain_id=66777901&record_id=1428269081&sub_domain=www&value=%ip%&record_type=A&record_line=默认"


pause
exit