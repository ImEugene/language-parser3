#<!--
###################################################################################
@main[]
<h1>Parser 3.x test page</h1>
<p>If you see this page, you have sucessfully installed Parser and trying to test it.</p>
<p>To see full paths to configuration files and DOCUMENT_ROOT comment out postprocess[] method.</p>
<p>If something is marked as red, then something is configured the wrong way or automatic detection is impossible
(related to library files and codepages search with relative paths).</p>
<hr />

^try{
	$status_rusage_begin[$status:rusage]
	$status_memory_begin[$status:memory]
}{
	$exception.handled(1)
}

<h2>Global variables defined in config auto.p</h2>

<h3>^$CHARSETS:</h3>
^if($CHARSETS && $CHARSETS is "hash"){
	<table cellpadding="5" cellspacing="0" border="1">
	^CHARSETS.foreach[sKey;sValue]{
		<tr>
			<td>$sKey</td>
			<td>$sValue (^check_system_file[$sValue])</td>
		</tr>
	}
	</table>
}{
	^error[Table with charset not defined.]
	<br />Probably parser can't find configuration auto.p which located near parser3 executable
	<br />����� ��������� � ���, ��� �� ��������������, �������� ����������
	^^throw[^;check auto.p execution] � ��� ����� &#64^;auto[] � ������������� ��������.
	��������� ������ ����� �� ������������ ����� ����������������� � ���, ��� �� �������������.
}

<h3>^$SQL:</h3>
^if($SQL && $SQL.drivers && $SQL.drivers is "table"){
	^try{
		<table cellpadding="5" cellspacing="0" border="1">
		<tr>
			<th>protocol</th>
			<th>parser driver</th>
			<th>sql client library</th>
		</tr>
		^SQL.drivers.menu{
			<tr>
				<td>$SQL.drivers.protocol</td>
				<td>^if(def $SQL.drivers.driver){$SQL.drivers.driver (^check_system_file[$SQL.drivers.driver])^if(!^check_p3_sql_lib_name[$SQL.drivers.driver;parser3]){<br />^error[�������, ��� ������ ������ ����?]}}{<br />}</td>
				<td>^if(def $SQL.drivers.client){$SQL.drivers.client (^check_system_file[$SQL.drivers.client])}{<br />}</td>
			</tr>
		}
		</table>
	}{
		$exception.handled(1)
		^error[^$SQL.drivers. Wrond data structure.]
		<br />Probably TABs characters was replaced by spaces characters while manual editing configuration auto.p
		<br />Table content:
		^printTable[$SQL.drivers]
	}
}{
	^error[^$SQL.drivers not defined.]
	<br />Probably parser can't find configuration auto.p
}

<p>
^info[DOCUMENT_ROOT]: ^if(^trim[$env:DOCUMENT_ROOT;/] eq $script_dir){equal with test script directory}{^error[^if(!def $env:DOCUMENT_ROOT){undefined}{&laquo^;wrong&raquo^; or test script located not in the DOCUMENT ROOT}]}^if(def $env:DOCUMENT_ROOT){ ($env:DOCUMENT_ROOT)}<br />
^info[���� � �������]: $script_dir<br />
^info[^$response:charset]: ^if(def $response:charset){$response:charset}{^error[Undefined. Are you use UTF8?]}<br />
^info[^$request:charset]: ^if(def $request:charset){$request:charset}{^error[Undefined. Are you use UTF8?]}<br />
^info[^$request:uri]: $request:uri<br />
^info[^$request:query]: $request:query^if(def $request:query){ (for get values use ^$form class)}<br />
^info[^$SQL.connect-string]: ^if(def ${SQL.connect-string}){defined}{^info[undefined]}<br />
^info[^$MAIL.SMTP]: ^if(def $MAIL.SMTP){defined}{undefined}<br />
^info[^$CLASS_PATH]:
^if($CLASS_PATH is "table"){
	<br />
	^try{
		<table cellpadding="5" cellspacing="0" border="1">
		^CLASS_PATH.menu{
			<tr>
				<td>$CLASS_PATH.path</td>
				<td>^check_dir[$CLASS_PATH.path]</td>
			</tr>
		}
		</table>
	}{
		$exception.handled(1)
		^error[^$CLASS_PATH. Wrong structure.]
		<br />^$CLASS_PATH. must contain string or named table with column 'path'.<br />
	}
}{
	^if(def $CLASS_PATH){$CLASS_PATH &mdash^; ^check_dir[$CLASS_PATH]}{^info[undefined]}<br />
}
</p>



<h2>Parser demo</h2>

<h3>Manipulations with cookie (class <a href="http://www.parser.ru/en/docs/lang/cookieclass.htm">^$cookie</a>)</h3>
<p>
Read ^$cookie:test: ^if(def $cookie:test){$cookie:test}{undefined}<br />
Write to cookie value ABC ^$cookie:test[ABC]$cookie:test[ABC] (press Reload)<br />
</p>



<h3>Math operations (class <a href="http://www.parser.ru/en/docs/lang/mathclass.htm">^$math</a>)</h3>
<p>
$math_string[StRiNg]
$math_salt[^$apr1^$]

$iNum1(^math:random(9)+1)
$iNum2(^math:random(9)+1)
^^eval($iNum1+$iNum2): ^eval($iNum1+$iNum2)<br />
^^math:random(1000): ^math:random(1000)<br />
^^math:log(1000): ^try_exec{^math:log(1000)}<br />
^^math:log10(1000): ^try_exec{^math:log10(1000)}<br />
^^math:uuid[]: ^try_exec{^math:uuid[]}<br />
^^math:uid64[]: ^try_exec{^math:uid64[]}<br />
^^math:md5[$math_string]: ^try_exec{^math:md5[$math_string]}<br />
^^math:crypt[$math_string;$math_salt]: ^try_exec{^math:crypt[$math_string;$math_salt]}<br />
^^math:crc32[$math_string]: ^try_exec{^math:crc32[$math_string]}<br />
</p>


<h3>Strings manipulations (class <a href="http://www.parser.ru/en/docs/lang/stringclass.htm">^$string</a>)</h3>
<p>
$upper[��]
$lower[��]
$mixed[��]
Definition ^$str[������] $str[������]<br />
String length ^^str.length[]: ^str.length[]<br />
Uppercase string ^^str.upper[]: ^str.upper[]^if(^mixed.upper[] ne $upper){ [^error[incorrect transformin to uppercase]]}<br />
Lowercase string ^^str.lower[]: ^str.lower[]^if(^mixed.lower[] ne $lower){ [^error[incorrect transformin to lowercase]]}<br />
First 2 chars ^^str.left(2): ^str.left(2)<br />
Last 3 chars ^^str.right(3): ^str.right(3)<br />
Substring ^^str.mid(1^;3): ^str.mid(1;3)<br />
Position of '�' char ^^str.pos[�]: ^str.pos[�]<br />
Position of '�' char starting from position 2 ^^str.pos[�](2): ^try_exec{^str.pos[�](2)}<br />
Position of 'X' char ^^str.pos[X]: ^str.pos[X]<br />
Replacement substring '��' to XX using match ^^str.match[��][]{XX}: ^str.match[��][]{XX}<br />
$repl[^table::create{a	b
�	Y
�	Z}]
Replacement chars '�' to 'Y', '�' to 'Z' using ^^str.replace[^$repl]: ^str.replace[$repl]<br />
^^str.trim[both;�]: ^try_exec{^str.trim[both;�]}<br />
^^str.trim[start;�]: ^try_exec{^str.trim[start;�]}<br />
^^str.trim[end;�]: ^try_exec{^str.trim[end;�]}<br />
^^str.trim[left;�]: ^try_exec{^str.trim[left;�]}<br />
^^str.trim[right;�]: ^try_exec{^str.trim[right;�]}<br />
^^str.base64[]: ^try_exec{$sBase64[^str.base64[]]$sBase64}<br />
^if(def $sBase64){
#	^^string:base64[$sBase64]: ^try_exec{^string:base64[$sBase64]}
}
^^str.js-escape[]: ^try_exec{$sEscaped[^str.js-escape[]]$sEscaped}<br />
^if(def $sEscaped){
	^^str:js-unescape[$sEscaped]: ^try_exec{^string:js-unescape[$sEscaped]}<br />
}
</p>


<h3>Working with class <a href="http://www.parser.ru/en/docs/lang/inetclass.htm">^$inet</a></h3>
^^inet:aton[10.0.0.2]: ^try_exec{^inet:aton[10.0.0.2]}<br />
^^inet:aton[192.168.1.5]: ^try_exec{^inet:aton[192.168.1.5]}<br />
^^inet:ntoa(167772162): ^try_exec{^inet:ntoa(167772162)}<br />
^^inet:ntoa(3232235781): ^try_exec{^inet:ntoa(3232235781)}<br />




<h3><a name="forms">Form values manipulations</a> (class <a href="http://www.parser.ru/en/docs/lang/formclass.htm">^$form</a>)</h3>
<p>
^$form:a: ^if(def $form:a){$form:a}{undefined}<br />
Safe conversion ^$form:a to integer: ^^form:a.int(1): ^form:a.int(1)<br />
^if($form:tables.b){
	^form:tables.b.menu{
		^form:tables.b.line[] value ^$form:b: $form:tables.b.field
	}[<br />]
}{
	^$form:b undefined
}
<br />
^$form:qtail: ^if(def $form:qtail){$form:qtail}{undefined}<br />
^if(!def $form:a){
	<a href="?a=321&b=^taint[uri][�]&b=^taint[uri][�]&b=^taint[uri][���]?ABC#forms">click here to check reading form values</a>
}
</p>

<h3>Manipulations with hash (class <a href="http://www.parser.ru/en/docs/lang/hashclass.htm">^$hash</a>)</h3>
<p>
<pre>
^$hash1[
&nbsp^;&nbsp^;^$.a[1]
&nbsp^;&nbsp^;^$.b[2]
&nbsp^;&nbsp^;^$.c[3]
]
^^hash1.foreach[key;value]{
&nbsp^;&nbsp^;^$key=^$value
}[&lt^;br /&gt^;]
</pre>
$hash1[
	$.a[1]
	$.b[2]
	$.c[3]
]
^hash1.foreach[key;value]{
	$key=$value
}[<br />]

<br /><br />
Checking item with key 'a' (^^hash1.contains[a]):
^try_exec{^if(^hash1.contains[a]){item with key 'a' exist}{^error[item with key 'a' doesn't exixt]}}
</p>


<h3>Manipulations with table (class <a href="http://www.parser.ru/en/docs/lang/tableclass.htm">^$table</a>)</h3>
<pre>^$tbl1[^^table::create{name	col1	col2
Vasya	3	5
Dima	4	14}]</pre>
$tbl1[^table::create{name	col1	col2
Vasya	3	5
Dima	4	14}]
^$tbl1 rows quantity: ^tbl1.count[]<br />
$col[^tbl1.columns[]]
^$tbl1 columns quantity: ^col.count[]<br />
Print columns:<br />
^printTable[$col]

<p>
Print content ^$tbl1:<br />
^printTable[$tbl1]
</p>

<pre>^$tbl2[^^table::create{name	col1	col2
Vova	3	44}]</pre>
$tbl2[^table::create{name	col1	col2
Vova	3	44}]
^$tbl2 rows quantity: ^tbl2.count[]<br />


<p>
join ^$tbl1 to ^$tbl2 [^^tbl2.join[^$tbl1]]<br />
^tbl2.join[$tbl1]
^$tbl2 rows quantity ^^tbl2.count[]: ^tbl2.count[]<br />
Print table:<br />
^printTable[$tbl2]
</p>

<p>select table rows where col1 values are equal 3: ^^tbl2.select(^$tbl2.col1 == 3)<br />
^printTable[^tbl2.select($tbl2.col1 == 3)]
</p>


<p>Making hash with tables (where hash keys are col1 values): ^$hData[^^tbl2.hash[col1][^$.distinct[tables]]]<br />
^try{
	$hData[^tbl2.hash[col1][$.distinct[tables]]]
	<p>Print hash data:
	<table cellpadding="2" cellspacing="0" border="1" width="35%">
	<tr align="center">
		<th>Key</th>
		<th>Value</th>
	</tr>
	^hData.foreach[sKey;tValue]{
		<tr>
			<td>$sKey</td>
			<td>^printTable[$tValue;100%]</td>
		</tr>
	}
	</table>
	</p>
}{
	$exception.handled(1)
	^error[Detected parser before 3.0.8. This method not exist.]
}
</p>

<p>Making hash with strings (where hash keys are col2 values and values are name values): ^$hData[^^tbl2.hash[col2^;name][^$.type[string]]]<br />
^try{
	$hData[^tbl2.hash[col2;name][$.type[string]]]
	<p>Print hash data:
	<table cellpadding="2" cellspacing="0" border="1">
	<tr align="center">
		<th>Key</th>
		<th>Value</th>
	</tr>
	^hData.foreach[sKey;sValue]{
		<tr>
			<td>$sKey</td>
			<td>$sValue</td>
		</tr>
	}
	</table>
	</p>
}{
	$exception.handled(1)
	^error[Detected parser before 3.2.2. This method not exist.]
}
</p>

<h3>Date manipulations (class <a href="http://www.parser.ru/en/docs/lang/dateclass.htm">^$date</a>)</h3>
<p>
^$now[^^date::now[]]<br />
$now[^date::now[]]
^$now.day/^$now.month/^$now.year ^${now.hour}:^${now.minute}:^$now.second: $now.day/$now.month/$now.year ${now.hour}:${now.minute}:$now.second<br />
^$now.week: ^try_exec{$now.week}<br />
^$now.weekyear: ^try_exec{$now.weekyear}<br />
Print now in sql format ^^now.sql-string[]: ^now.sql-string[]<br />
Print now in UNIX timestamp format ^^now.unix-timestamp[]: ^try_exec{^now.unix-timestamp[]}<br />
Print now in GMT format ^^now.gmt-string[]: ^try_exec{^now.gmt-string[]}<br />
Number of last day in current month ^^now.last-day[]: ^try_exec{^now.last-day[]}<br />
^now.roll[day](-5)
Roll date to 5 days ahead ^^now.roll[day](-5): ^printDate[$now]<br />
^now.roll[day](30)
Roll date to 30 days behind ^^now.roll[day](30): ^printDate[$now]<br />
</p>




<h3>Manipulations with files (class <a href="http://www.parser.ru/en/docs/lang/fileclass.htm">^$file</a>)</h3>
<p>
$save_table_name[_test.cfg]
$fname[$save_table_name]
Write table ^$tbl1 to file $save_table_name (^^tbl1.save[$fname]):
$no_file(0)
^try{
	^tbl1.save[$fname]
	^info[File created successfully]
}{
	^if($exception.type eq "file.access"){
		$exception.handled(1)
		$no_file(1)
		^error[access denied]
	}
}
<br />
^^file:dirname[/$save_table_name]: ^try_exec{^file:dirname[/$save_table_name]}<br />
^^file:basename[/$save_table_name]: ^try_exec{^file:basename[/$save_table_name]}<br />
^^file:justname[/$save_table_name]: ^try_exec{^file:justname[/$save_table_name]}<br />
^^file:justext[/$save_table_name]: ^try_exec{^file:justext[/$save_table_name]}<br />

</p>
^if(!$no_file){
	<p>Get saved file information ^$fstat[^^file::stat[$fname]]:<br />
	$fstat[^file::stat[$fname]]
	File size [^$fstat.size]: $fstat.size<br />
	cdate: $fstat.cdate.day/$fstat.cdate.month/$fstat.cdate.year<br />
	adate: ^printDate[$fstat.adate]<br />
	mdate: ^printDate[$fstat.mdate]<br />
	</p>

	<p>
	Loading data into ^$tbl3 from file DOCUMENT_ROOT/$save_table_name and out table content (^$tbl3[^^table::load[$fname]]):<br />
	^if(-f $fname){
		$tbl3[^table::load[$fname]]
		^printTable[$tbl3]
	}
	</p>

	<p>File copy (^^file:copy[$fname^;_copy.cfg]):
	^try_exec{
		^file:copy[$fname;_copy.cfg]^info[ok]
		^try{
			^file:delete[_copy.cfg]
		}{
			$exception.handled(1)
		}
	}
	</p>

	<p>File delete (^^file:delete[$fname]):
		^try{
			^file:delete[$fname]
			^info[ok]
		}{
			$exception.handled(1)
			^error[error during file deletion]
		}
	</p>
}


<h3>Working with class <a href="http://www.parser.ru/en/docs/lang/hashfileclass.htm">^$hashfile</a></h3>
$hashfile_name[_test]
<p>Create object: ^$hf [^$hf[^^hashfile::open[$hashfile_name]]]:
^try{
	$hf[^hashfile::open[$hashfile_name]]
	^info[object was created sucessfully]<br />

	$expires(3)
	$hash1[^hf.hash[]]
	Number of records: ^hash1._count[]<br />

	^try{
		$key[^math:uuid[]]
	}{
		$exception.handled(1)
		$key[^math:random(999999999)]
	}
	Adding record ($key) for $expires days:
	$value[^math:random(999999999)]
	<pre>
	^$hf.[$key][
	 &nbsp^; &nbsp^;^$.value[$value]
	 &nbsp^; &nbsp^;^$.expires($expires)
	]
	</pre>
	$hf.[$key][
		$.value[$value]
		$.expires($expires)
	]

	Cleanup hashfile from expired records (^^hf.cleanup[]):
	^try_exec{^hf.cleanup[]^info[ok]}<br /><br />

	$limit(5)
	Print hashfile content (max $limit records):<br />
	$cnt(0)
	^hf.foreach[k;v]{^if($cnt < $limit){
		$k=^v.format[%d]<br />
		^cnt.inc(1)
	}}
	<br />

	Close hashfile files and release locks (^^hf.release[]):
	^try_exec{^hf.release[]^info[ok]}<br />
}{
	$exception.handled(1)
	^if($exception.type eq "file.access"){
		^error[access denied]
	}{
		^error[can't create object]
	}
}
</p>


<h3>Manipulations with enviroment variables (class <a href="http://www.parser.ru/en/docs/lang/envclass.htm">^$env</a>)</h3>
$env_table[^table::create{name	description
SERVER_NAME	DNS Server name
QUERY_STRING	For get values use ^$form class
HTTP_REFERER
HTTP_USER_AGENT	Browser USER_AGENT string
HTTP_X_FORWARDED_FOR	Filled if visitor come through proxy server
REMOTE_HOST
REMOTE_ADDR	Visitors' IP address
PARSER_VERSION	Parser3 version (if not defined - parser3 before 3.1.5)
}]

$is_env_defined(0)
<table cellpadding="2" cellspacing="0" border="1">
	<tr>
		<th>Variable</th>
		<th>Value</th>
		<th><a href="http://hoohoo.ncsa.uiuc.edu/cgi/env.html">Comment</a></th>
	</tr>
^env_table.menu{
		<tr>
			<td>$env_table.name</td>
			<td>^if(def $env:[$env_table.name]){$env:[$env_table.name]^is_env_defined.inc(1)}{<br />}</td>
			<td>^if(def $env_table.description){$env_table.description}{<br />}</td>
		</tr>
	}
</table>
^if(!$is_env_defined){
	<p>^error[No one enviroment variable defined.]</p>
}




<h3>Working with SQL</h3>
<p>
^if(def ${SQL.connect-string}){
	$sqlquery[SELECT 2+2^if(^SQL.connect-string.left(6) eq "oracle"){ from dual}]
	^^int:sql{$sqlquery}:
	^try{
		^connect[$SQL.connect-string]{
			$sqlTest(^int:sql{$sqlquery}[$default{0}])
		}
		$sqlTest^if($sqlTest != 4){ [^error[Ups. You SQL server calculate 2+2 very strange...]]}<br />
^rem{
#		��������������, �.�. �� �������...
		$lower_string[���]
		$upper_string[���]
		<p>SQL �������������� ����� � �������� ��������:
		^connect[$SQL.connect-string]{
			^try{
				$test_string[^string:sql{SELECT UPPER('$lower_string')}[$.default{}]]
				^if($upper_string eq $test_string){
					��������� ��������� ���������
				}{
					��������� ��������� �� ���������. �������� ������: '$lower_string'. ���������: '$test_string'. ������ ����: '$upper_string'.
				}
			}{
				<b>��������� ������� �� �������� ��� ������ SQL �������.</b>
				$exception.handled(1)
			}
		}
		</p>
}
	}{
		^if($exception.type eq "sql.connect"){
			^error[Can't connect to SQL server.] Probably wrong username/password combination or incorrect connection string.
			$exception.handled(1)
		}{
			^if($exception.type eq "sql.execute"){
				^error[Query execution error.], but connection to SQL server establish successfully. So strange, because SQL query is very simple
				$exception.handled(1)
			}{
				^error[Problems with SQL operations.] Probably SQL drivers not found.
				<br />Error message:
				<blockquote>
					^taint[html][$exception.comment]
					^if(def $exception.source){<br /><b>^taint[html][$exception.source]</b>}
				</blockquote>
				$exception.handled(1)
			}
		}
	}
}{
	^error[^$SQL.connect-string not defined]. Testing impossible.
}
</p>


<h3>Manipulations with XML</h3>
<p>
Create xdoc:<br />
^try{
	$xml_txt[<?xml version="1.0" encoding="$request:charset" ?>
<document>
	<t attr="Hello" n="123"/>
	<t attr="Bye" n="234" n2="xxx"/>
	<text>Text</text>
</document>]
	<pre>
	^taint[html][^$document[^^xdoc::create{$xml_txt}]]
	</pre>
	$document[^xdoc::create{$xml_txt}]
	Object xdoc created successfully.<br />

	Get ^taint[html][<t />] elements ^$elements[^^document.select[//t]] :<br />
	$elements[^document.select[//t]]
	^taint[html][<t />] elements quantity: ^elements._count[]<br />
	Print elements using foreach:<br >
	^elements.foreach[key;node]{
    	name: '$node.nodeName', type: '$node.nodeType', attributes quantity: '^node.attributes._count[]', attributes: ^node.attributes.foreach[akey;aval]{$akey='$aval.value'}[, ]
    }[<br />]
}{
	^if($exception.type eq "parser.runtime"){
		^error[You need install parser with XML...] Probably XML libs not installed properly...
		$exception.handled(1)
	}
	^if($exception.type eq "xml"){
		$no_file(1)
		$exception.handled(1)
		^error[Problems with XML operations...] Probable because of charset problems...
		<br />��������� �� ������:
		<blockquote>
			^taint[html][$exception.comment]
			^if(def $exception.source){<br /><b>^taint[html][$exception.source]</b>}
		</blockquote>
	}
}
</p>


<h3>Working with classes <a href="http://www.parser.ru/en/docs/lang/statusclass.htm">Status</a> and <a href="http://www.parser.ru/en/docs/lang/memoryclass.htm">Memory</a></h3>
$fields[^table::create{section	name	measure	description
rusage	utime	secs	process time
rusage	stime	secs	time for reading files
rusage	maxrss	blocks	memory, used by process
memory	used	KB	user
memory	free	KB	free (fragmentated)
memory	ever_allocated_since_compact	KB	allocated since last garbage collection
memory	ever_allocated_since_start	KB	allocated since start
}]

<p>
	^try{
		<table cellpadding="2" cellspacing="0" border="1">
		<tr>
			<th rowspan="2">Field</th>
			<th rowspan="2">Description</th>
			<th colspan="3">Value</th>
		</tr>
		<tr>
			<th>on start</th>
			<th>now</th>
			<th>after ^^memory:compact[]</th>
		</tr>
		$status_rusage_now[$status:rusage]
		$status_memory_now[$status:memory]
		^try{
			$tbl1[]
			$tbl2[]
			$tbl3[]
			$hash1[]
			$document[]
			$elements[]
			$tables_hash[]
			$hf[]
			$k[]
			$v[]

			^memory:compact[]
			^memory:compact[]
			$is_compact_work(1)
			$status_rusage_compact[$status:rusage]
			$status_memory_compact[$status:memory]
		}{
			$exception.handled(1)
		}
		^fields.menu{
			<tr>
				<td>^$status:${fields.section}.$fields.name^if(def $fields.measure){ ($fields.measure)}</td>
				<td>$fields.description</td>
				<td>^if($fields.section eq "rusage"){$status_rusage_begin.[$fields.name]}{$status_memory_begin.[$fields.name]}</td>
				<td>^if($fields.section eq "rusage"){$status_rusage_now.[$fields.name]}{$status_memory_now.[$fields.name]}</td>
				^if(!$is_compact_work && ^fields.line[] == 1){
					<td rowspan="^fields.count[]">^error[Method doesn't exist in used parser3 version.]</td>
				}{
					<td>^if($fields.section eq "rusage"){$status_rusage_compact.[$fields.name]}{$status_memory_compact.[$fields.name]}</td>
				}
			</tr>
		}
		</table>
	}{
		$exception.handled(1)
		^error[In this parser3 version methods ^$status:rusage or ^$status:memory doesn't works.]
	}
</p>
#end @main[]



###########################################################################
@auto[filespec]
^if(def $filespec){
	$script_dir[^trim[^filespec.match[/(?:\w+\.html?)?^$][i]{/};/]]
}
$document_root[^if(def $env:DOCUMENT_ROOT){$env:DOCUMENT_ROOT}{$script_dir}]
#end @auto[]




###########################################################################
# trim leading and trailing chars $char (spaces by default)
@trim[str;char][chr;tbl]
^if(def $str){
	$chr[^if(def $char){$char}{\s}]
	$str[^str.match[^^$chr*][]{}]
	$tbl[^str.match[^^(.*[^^$chr])$chr*^$]]
	$result[$tbl.1]
}{
	$result[]
}
#end @trim[]



###########################################################################
@check_dir[dir]
^if(def $dir && -d $dir){directory exist}{^error[directory doesn't exist]}
#end @check_dir[]



###########################################################################
# get relative path to file
@get_relative_path[from;to][ff;tt;f;t;p;up;ne;pos;i;down]
$ff[^trim[^from.match[\\][g]{/};/]]
$tt[^trim[^to.match[\\][g]{/};/]]
$f[^ff.lsplit[/]]
$t[^tt.lsplit[/]]

$p[]
$up[/]
$ne(0)
$pos(0)
^for[i](1;^f.count[]){
	^if(!$ne && $f.piece eq $t.piece){
		$p[${p}$f.piece/]
		$pos($i)
	}{
		$ne($i)
		$up[${up}../]
	}
	^f.offset(1)
	^t.offset(1)
}
$down[]
^for[i]($pos;^t.count[]-1){
	^t.offset[set]($i)
	$down[${down}$t.piece^if($i != ^t.count[]-1){/}]
}
$result[${up}$down]
#end @get_relative_path[]



###########################################################################
# override unhandled_exception for show parser error (if occur) in this test
@unhandled_exception[exception;stack]
$response:status(500)
<html>
<head><title>Unhandled Exception</title></head>
<body>
<H1>Unhandled Exception</H1>
<pre>^taint[html][$exception.comment]</pre>
^if(def $exception.source){
	<b>$exception.source</b><br>
	<pre>^taint[html][$exception.file^($exception.lineno^)]</pre>
}
^if(def $exception.type){exception.type=$exception.type}
^if($stack){
	<hr />
	^stack.menu{<tt>$stack.name</tt> $stack.file^($stack.lineno^)<br>}
}
#for [x] MSIE friendly
<span style="font-size:1px">^for[i](0;512/7){&nbsp^;}</span>
</body>
#end @unhandled_exception[]



###########################################################################
@printDate[dtDate]
$result[^if($dtDate is "date"){$dtDate.day/$dtDate.month/$dtDate.year}]
#end @printDate[dt]



###########################################################################
@printTable[tTable;sTableWidth][tCols;sColumnWidth]
^if($tTable is "table" && $tTable){
	<table cellpadding="3" cellspacing="0" border="1"^if(def $sTableWidth){ width="$sTableWidth"}>
	$tCols[^tTable.columns[]]
	$sColumnWidth[^eval(100/(^tCols.count[]+1))[%d]]
	<tr>
		<th width="^eval(100-$sColumnWidth*^tCols.count[])%">string</th>
		^tCols.menu{<th width="$sColumnWidth%">$tCols.column</th>}
	</tr>
	^tTable.menu{
		<tr>
			<td>^tTable.line[]</td>
			^tCols.menu{<td>$tTable.[$tCols.column]</td>}
		</tr>
	}
	</table>
}
#end @printTable[]



###########################################################################
@update_pattern[text]
^if(def $text){
	$result[^text.match[(\\|\.)][g]{\$match.1}]
}{
	$result[]
}
#end @update_pattern[]



###########################################################################
@error[text]
$result[<b style="color:red">$text</b>]
#end @error[]



###########################################################################
@info[text]
$result[<b>$text</b>]
#end @info[]



###########################################################################
# use postprocess for cut paths and don't show them to everyones
@postprocess[sBody]
$result[$sBody]
^if(def $sqldriversdir){$result[^result.match[^update_pattern[$sqldriversdir]][gi]{^$sqldriversdir}]}
^if(def $charsetsdir){$result[^result.match[^update_pattern[$charsetsdir]][gi]{^$charsetsdir}]}
^if(def $document_root){$result[^result.match[^update_pattern[$document_root]][gi]{comment postprocess method for view}]}
^if(def $script_dir){$result[^result.match[^update_pattern[$script_dir]][gi]{comment postprocess method for view}]}
#end @postprocess[]



###########################################################################
# check file
@check_system_file[path][relative_path;file_stat;path_drive;root_drive]
^if(def $path){
	$path_drive[^get_drive_letter[$path]]
	^if(^path.left(1) ne "/" && !^path.match[^^[a-z]:\\][i]){
		$result[relative path. ^info[checkout is impossible]]
	}{
		^if(def $path_drive && $path_drive ne ^get_drive_letter[$document_root]){
			$result[^info[on different drive, checkout is impossible]]
}{
			^rem{ *** path started with X:\\ - win paths, case insensitive *** }
			$path[^path.match[^^[a-z]:\\(.+)][i]{^match.1.lower[]}]

			$relative_path[^get_relative_path[$document_root;$path]]
			^if(-f $relative_path){
				^try{
					$file_stat[^file::stat[$relative_path]]
					$result[^if(!$file_stat.size){^error[$file_stat.size Bytes]}{$file_stat.size Bytes}]
				}{
					$exception.handled(1)
					$result[found but ^error[access denied]]
				}
			}{
				$result[^error[not found]]
			}
		}
}
}{
	$result[]
}
#end @check_system_file[]



###########################################################################
@get_drive_letter[sPath]
$result[]
^sPath.match[^^([a-z]):(?:\\|/).+][i]{$result[^match.1.lower[]]}
#end @get_drive_letter[]



###########################################################################
# check parser3 sql lib name (many people write path to sql client lib but not parser3 lib)
@check_p3_sql_lib_name[sFile;sPattern][tPart]
$result(1)
^if(def $sFile){
	$tPart[^sFile.rsplit[/]]
	^if(!^tPart.piece.match[$sPattern]){$result(0)}
}
#end @check_p3_sql_lib_name[]



###########################################################################
@try_exec[jCode;sErrorInfo]
^try{
	$result[$jCode]
}{
	$exception.handled(1)
	$result[^error[^if(def $sErrorInfo){$sErrorInfo}{Used Parser 3 version don't have this feature.}]]
}
#end @try_exec[]
#--> To make this test work, Parser should be made a processor of documents with this extention, what now is not observed. #
