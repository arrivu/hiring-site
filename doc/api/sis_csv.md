SIS Import Format Documentation
===============================

Instructure Hiring can integrate with an institution's Candidate Information Services in
several ways. The simplest way involves providing Hiring with several CSV files describing
users, projects, and enrollments.
These files can be zipped together and uploaded to the Account admin area.

Standard CSV rules apply:

* The first row will be interpreted as a header defining the ordering of your columns. This
header row is mandatory.
* Fields that contain a comma must be surrounded by double-quotes.
* Fields that contain double-quotes must also be surrounded by double-quotes, with the
internal double-quotes doubled. Example: Chevy "The Man" Chase would be included in
the CSV as "Chevy ""The Man"" Chase".

All text should be UTF-8 encoded.

All timestamps are sent and returned in ISO 8601 format.  All timestamps default to UTC time zone
unless specified.

    YYYY-MM-DDTHH:MM:SSZ

Batch Mode
----------

If the option to do a "full batch update" is selected in the UI, then this SIS upload is considered
to be the new canonical set of data, and data from previous SIS imports that isn't present in
this import will be deleted. This can be useful if the source SIS software doesn't have a way
to send delete records as part of the import. This deletion is scoped to a single term, which
must be specified when uploading the SIS import. Use this option with caution, as it can delete
large data sets without any prompting on the individual records. Currently, this affects projects,
batchs and enrollments.

This option will only affect data created via previous SIS imports. Manually created projects, for
example, won't be deleted even if they don't appear in the new SIS import.

users.csv
---------

<table class="sis_csv">
<tr>
<th>Field Name</th>
<th>Data Type</th>
<th>Description</th>
</tr>
<tr>
<td>user_id</td>
<td>text</td>
<td><b>Required field</b>. A unique identifier used to reference users in the enrollments table.
This identifier must not change for the user, and must be globally unique. In the user interface,
 this is called the SIS ID.</td>
</tr>
<tr>
<td>login_id</td>
<td>text</td>
<td><b>Required field</b>. The name that a user will use to login to Instructure. If you have an
authentication service configured (like LDAP), this will be their username
from the remote system.</td>
</tr>
<tr>
<td>password</td>
<td>text</td>
<td><p>If the account is configured to use LDAP or an SSO protocol then
this isn't needed. Otherwise this is the password that will be used to
login to Hiring along with the 'login_id' above.</p>
<p>If the user already has a password (from previous SIS import or
otherwise) it will <em>not</em> be overwritten</p></td>
</tr>
<tr>
<td>first_name</td>
<td>text</td>
<td>Given name of the user.</td>
</tr>
<tr>
<td>last_name</td>
<td>text</td>
<td>Last name of the user.</td>
</tr>
<tr>
<td>email</td>
<td>text</td>
<td>The email address of the user. This might be the same as login_id, but should
still be provided.</td>
</tr>
<tr>
<td>status</td>
<td>enum</td>
<td><b>Required field</b>. active, deleted</td>
</tr>
</table>

<p>When a candidate is 'deleted' all of its enrollments will also be deleted and
they won't be able to log in to the school's account. If you still want the
candidate to be able to log in but just not participate, leave the candidate
'active' but set the enrollments to 'completed'.</p>

Sample:

<pre>
user_id,login_id,password,first_name,last_name,email,status
01103,bsmith01,,Bob,Smith,bob.smith@myschool.edu,active
13834,jdoe03,,John,Doe,john.doe@myschool.edu,active
13aa3,psue01,,Peggy,Sue,peggy.sue@myschool.edu,active
</pre>

accounts.csv
------------

<table class="sis_csv">
<tr>
<th>Field Name</th>
<th>Data Type</th>
<th>Description</th>
</tr>
<tr>
<td>account_id</td>
<td>text</td>
<td><b>Required field</b>. A unique identifier used to reference accounts in the enrollments data.
This identifier must not change for the account, and must be globally unique. In the user
interface, this is called the SIS ID.</td>
</tr>
<tr>
<td>parent_account_id</td>
<td>text</td>
<td>The account identifier of the parent account.
If this is blank the parent account will be the root account.</td>
</tr>
<tr>
<td>name</td>
<td>text</td>
<td><b>Required field</b>. The name of the account</td>
</tr>
<tr>
<td>status</td>
<td>enum</td>
<td><b>Required field</b>. active, deleted</td>
</tr>
</table>

Any account that will have child accounts must be listed in the csv before any child account
references it.

Sample:

<pre>
account_id,parent_account_id,name,status
A001,,Humanities,active
A002,A001,English,active
A003,A001,Spanish,active
</pre>

hiring_periods.csv
------------

<table class="sis_csv">
<tr>
<th>Field Name</th>
<th>Data Type</th>
<th>Description</th>
</tr>
<tr>
<td>hiring_period_id</td>
<td>text</td>
<td><b>Required field</b>. A unique identifier used to reference hiring periods in the enrollments data.
This identifier must not change for the account, and must be globally unique. In the user
interface, this is called the SIS ID.</td>
</tr>
<tr>
<td>name</td>
<td>text</td>
<td><b>Required field</b>. The name of the term</td>
</tr>
<tr>
<td>status</td>
<td>enum</td>
<td><b>Required field</b>. active, deleted</td>
</tr>
<tr>
<td>start_date</td>
<td>date</td>
<td>The date the term starts. The format should be in ISO 8601: YYYY-MM-DDTHH:MM:SSZ</td>
</tr>
<tr>
<td>end_date</td>
<td>date</td>
<td>The date the term ends. The format should be in ISO 8601: YYYY-MM-DDTHH:MM:SSZ</td>
</tr>
</table>

Any account that will have child accounts must be listed in the csv before any child account
references it.

Sample:

<pre>
hiring_period_id,name,status,start_date,end_date
T001,Winter2011,active,,
T002,Spring2011,active,2013-1-03 00:00:00,2013-05-03 00:00:00-06:00
T003,Fall2011,active,,
</pre>

projects.csv
------------

<table class="sis_csv">
<tr>
<th>Field Name</th>
<th>Data Type</th>
<th>Description</th>
</tr>
<tr>
<td>project_id</td>
<td>text</td>
<td><b>Required field</b>. A unique identifier used to reference projects in the enrollments data.
This identifier must not change for the account, and must be globally unique. In the user
interface, this is called the SIS ID.</td>
</tr>
<tr>
<td>short_name</td>
<td>text</td>
<td><b>Required field</b>. A short name for the project</td>
</tr>
<tr>
<td>long_name</td>
<td>text</td>
<td><b>Required field</b>. A long name for the project. (This can be the same as the short name,
but if both are available, it will provide a better user experience to provide both.)</td>
</tr>
<tr>
<td>account_id</td>
<td>text</td>
<td>The account identifier from accounts.csv, if none is specified the project will be attached to
the root account</td>
</tr>
<tr>
<td>hiring_period_id</td>
<td>text</td>
<td>The hiring period identifier from hiring_periods.csv, if no hiring_period_id is specified the
default hiring period for the account will be used</td>
</tr>
<tr>
<td>status</td>
<td>enum</td>
<td><b>Required field</b>. active, deleted, completed</td>
</tr>
<tr>
<td>start_date</td>
<td>date</td>
<td>The project start date. The format should be in ISO 8601: YYYY-MM-DDTHH:MM:SSZ</td>
</tr>
<tr>
<td>end_date</td>
<td>date</td>
<td>The project end date. The format should be in ISO 8601: YYYY-MM-DDTHH:MM:SSZ</td>
</tr>
</table>

<p>If the start_date is set, it will override the hiring period start date. If the end_date is set, it will
override the hiring period end date.</p>

Sample:

<pre>
project_id,short_name,long_name,account_id,hiring_period_id,status
E411208,ENG115,English 115: Intro to English,A002,,active
R001104,BIO300,"Biology 300: Rocking it, Bio Style",A004,Fall2011,active
A110035,ART105,"Art 105: ""Art as a Medium""",A001,,active
</pre>

batchs.csv
------------

<table class="sis_csv">
<tr>
<th>Field Name</th>
<th>Data Type</th>
<th>Description</th>
</tr>
<tr>
<td>batch_id</td>
<td>text</td>
<td><b>Required field</b>. A unique identifier used to reference batchs in the enrollments data.
This identifier must not change for the account, and must be globally unique. In the user
interface, this is called the SIS ID.</td>
</tr>
<tr>
<td>project_id</td>
<td>text</td>
<td><b>Required field</b>. The project identifier from projects.csv</td>
</tr>
<tr>
<td>name</td>
<td>text</td>
<td><b>Required field</b>. The name of the batch</td>
</tr>
<tr>
<td>status</td>
<td>enum</td>
<td><b>Required field</b>. active, deleted</td>
</tr>
<tr>
<td>start_date</td>
<td>date</td>
<td>The batch start date. The format should be in ISO 8601: YYYY-MM-DDTHH:MM:SSZ</td>
</tr>
<tr>
<td>end_date</td>
<td>date</td>
<td>The batch end date The format should be in ISO 8601: YYYY-MM-DDTHH:MM:SSZ</td>
</tr>
</table>

<p>If the start_date is set, it will override the project and hiring period start dates. If the end_date is
set, it will override the project and hiring period end dates.</p>

Sample:

<pre>
batch_id,project_id,name,status,start_date,end_date
S001,E411208,batch 1,active,,
S002,E411208,batch 2,active,,
S003,R001104,batch 1,active,,
</pre>

enrollments.csv
---------------

<table class="sis_csv">
<tr>
<th>Field Name</th>
<th>Data Type</th>
<th>Description</th>
</tr>
<tr>
<td>project_id</td>
<td>text</td>
<td><b>Required field if batch_id is missing</b>. The project identifier from projects.csv</td>
</tr>
<tr>
<td>user_id</td>
<td>text</td>
<td><b>Required field</b>. The User identifier from users.csv</td>
</tr>
<tr>
<td>role</td>
<td>text</td>
<td><b>Required field</b>. candidate, hiringmanager, ta, observer, designer, or a custom role defined
by the account</td>
</tr>
<tr>
<td>batch_id</td>
<td>text</td>
<td><b>Required field if project_id missing</b>. The batch identifier from batchs.csv, if none
is specified the default batch for the project will be used</td>
</tr>
<tr>
<td>status</td>
<td>enum</td>
<td><b>Required field</b>. active, deleted, completed</td>
</tr>
<tr>
<td>associated_user_id</td>
<td>text</td>
<td>For observers, the user identifier from users.csv of a candidate
in the same project that this observer should be able to see grades for.
Ignored for any role other than observer</td>
</tr>
</table>


When an enrollment is in a 'completed' state the candidate is limited to read-only access to the
project.


Sample:

<pre>
project_id,user_id,role,batch_id,status
E411208,01103,candidate,1B,active
E411208,13834,candidate,2A,active
E411208,13aa3,hiringmanager,2A,active
</pre>

groups.csv
------------

<table class="sis_csv">
<tr>
<th>Field Name</th>
<th>Data Type</th>
<th>Description</th>
</tr>
<tr>
<td>group_id</td>
<td>text</td>
<td><b>Required field</b>. A unique identifier used to reference groups in the group_users data.
This identifier must not change for the group, and must be globally unique.</td>
</tr>
<tr>
<td>account_id</td>
<td>text</td>
<td>The account identifier from accounts.csv, if none is specified the group will be attached to
the root account.</td>
</tr>
<tr>
<td>name</td>
<td>text</td>
<td><b>Required field</b>. The name of the group.</td>
</tr>
<tr>
<td>status</td>
<td>enum</td>
<td><b>Required field</b>. available, closed, completed, deleted</td>
</tr>
</table>

Sample:

<pre>
group_id,account_id,name,status
G411208,A001,Group1,available
G411208,,Group2,available
G411208,,Group3,deleted
</pre>

groups_membership.csv
------------

<table class="sis_csv">
<tr>
<th>Field Name</th>
<th>Data Type</th>
<th>Description</th>
</tr>
<tr>
<td>group_id</td>
<td>text</td>
<td><b>Required field</b>. The group identifier from groups.csv</td>
</tr>
<tr>
<td>user_id</td>
<td>text</td>
<td><b>Required field</b>. The user identifier from users.csv</td>
</tr>
<tr>
<td>status</td>
<td>enum</td>
<td><b>Required field</b>. accepted, deleted</td>
</tr>
</table>

Sample:

<pre>
group_id,user_id,status
G411208,U001,accepted
G411208,U002,accepted
G411208,U003,deleted
</pre>

xlists.csv
----------

<table class="sis_csv">
<tr>
<th>Field Name</th>
<th>Data Type</th>
<th>Description</th>
</tr>
<tr>
<td>xlist_project_id</td>
<td>text</td>
<td><b>Required field</b>. The project identifier from projects.csv</td>
</tr>
<tr>
<td>batch_id</td>
<td>text</td>
<td><b>Required field</b>. The batch identifier from batchs.csv</td>
</tr>
<tr>
<td>status</td>
<td>enum</td>
<td><b>Required field</b>. active, deleted</td>
</tr>
</table>

xlists.csv is optional. The goal of xlists.csv is to provide a way to add cross-listing
information to an existing project and batch hierarchy. batch ids are expected to exist
already and already reference other project ids. If a batch id is provided in this file,
it will be moved from its existing project id to a new project id, such that if that new project
is removed or the cross-listing is removed, the batch will revert to its previous project id.
If xlist_project_id does not reference an existing project, it will be created. If you want to
provide more information about the cross-listed project, please do so in projects.csv.

Sample:

<pre>
xlist_project_id,batch_id,status
E411208,1B,active
E411208,2A,active
E411208,2A,active
</pre>
