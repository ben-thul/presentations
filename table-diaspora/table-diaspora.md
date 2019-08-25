---
theme : "serif"
transition: "fade"
highlightTheme: "darkula"
logoImg: "https://raw.githubusercontent.com/evilz/vscode-reveal/master/images/logo-v2.png"
slideNumber: true
---

# Table Disaspora

### How to move a bunch of data with no downtime.

<small>Created by Ben Thul «[ben.thul@gmail.com](mailto://ben.thul@gmail.com)»</small>

---

Themes

<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/black.css'); return false;">Black (default)</a> -
<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/white.css'); return false;">White</a> -
<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/league.css'); return false;">League</a> -
<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/sky.css'); return false;">Sky</a> -
<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/beige.css'); return false;">Beige</a> -
<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/simple.css'); return false;">Simple</a> <br>
<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/serif.css'); return false;">Serif</a> -
<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/blood.css'); return false;">Blood</a> -
<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/night.css'); return false;">Night</a> -
<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/moon.css'); return false;">Moon</a> -
<a href="#" onclick="document.getElementById('theme').setAttribute('href','css/theme/solarized.css'); return false;">Solarized</a>

---

### The Problem™

* All tables in one database<!-- .element: class="fragment" -->
* Some belong there, others don't<!-- .element: class="fragment" -->
* Various data access methods (i.e. procs, ORMs)<!-- .element: class="fragment" -->

---

### Options

* Bring down the application, transfer, bring up
    * For tables of any size, this is site down
* Application does double writes
    * Costly in terms of AppEng effort
    * How to backfill historical data?

---

### The Solution™

* Create empty table in target
* Put triggers on the affected tables at source
  * Initially for updates and deletes only
* Use SSIS to transfer historical data source → target
* Once Transfer is done, insert trigger on source table
* Validate data
* Do cutover

---

# Thanks for coming!

---

## Triggers‽

* DBA Boogeyman told you "never use triggers"
  * To implement business logic
  * Pretty handy for simple things though
  * We'll use these to shadow copy DML source → target

---

## Transfer data

### Simple SSIS package per table

* Gets max(PK) from target table
* Queries source table for PK > max(PK)
* Transfers data source → target

---

### Data Validation

* Validation Artifacts
  * Missing data
  * Extra data
  * Different data
    * Checksum of the columns as computed column
      * Cheap to implement
      * Can be indexed for comparison

---

### Lying to your applications 
* Use synonyms at various levels to hide that you've moved the table
  * Initially, synonym for the table
  * Then, synonyms for modules (i.e. procedures, functions)
    * Cross-database permissions handled with module signing
* Once synonyms are in place, copy any modules to target
* Application can cutover to target
* Clean up source

---

# Module Signing

--

### Module signing

* Allows for users calling modules to get "extra" permissions only for proc call
* Alternatives
  * Could grant explicit permissions to underlying table
    * Not great as once the procs and table are in the same table, perms not needed
  * Enable cross-database permission chaining
    * Several security issues
* Module signatures get dropped on alter, though.

---

### Autopen

* To get around dropped/missing signatures, create an automated process to add signatures to modules that need them
  * DDL trigger for create/alter on procs/functions/triggers
  * Drives off of table with (Schema, Object, Certificate) tuples
* Ensures that the right signatures are on the right objects

---

### BIML

* Not just for creating the SSIS packages
* Also creates scripts for the:
  * `mssql-scripter` commands for target table creation
  * Triggers
  * Checksum column
  * Validation script

---

# Demo Time