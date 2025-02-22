![Image text](image/apache-license.png)


正则表达式：
t[ae]st，包含tast或test的单词；
[^g]oo，不包含goo的；
[^a-z]oo，不是以小写字母+oo的；
^[a-z]，行开头是小写字母的；
\.$，行末尾以点结束的
^$，空白行的；
g..d，g??d 的字符串；
ooo*，至少两个o以上的字符串，从0开始，*是重复0到无穷多个的前一个字符
g.*g，以g开头以g结尾的；
go\{2,5\}g，g 后面接 2 到 5 个 o；

grep -v "^#" file| grep -v "^$" | grep "^[a-zA-Z]" | wc -   #去除开头#的行，去除空白行
#去除开头为英文字母的那几行， 统计总行数

