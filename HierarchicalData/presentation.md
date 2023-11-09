---
marp: true
class: invert
auto-scaling: true
style: |
  h1,h2,h3 {
    text-align: center;
  }

---

# 🌲🌲🌲Trees Everywhere!🌲🌲🌲

## Querying Hierarchical Data

---

# About 
![bg right w:90%](e-mail.svg)
- Ben Thul (he/him)
- Your Internet Friend™
- Database Engineer since 2006
- 📧 [ben.thul@gmail.com](mailto:ben.thul@gmail.com)

---

# Why Do I Care?

![bg right w:90%](shrug.svg)

---

## Why Do I Care?

Trees are good for modeling certain real-world phenomena
- Organizational Charts
- Taxonomies (e.g. Domain → Kingdom → Phylum → etc…)
- Hierarchical Categories (e.g. Country → Province → City → etc…)
- Bill of Materials (e.g. 'Bicycle' needs 'Wheel' x 2; 'Wheel' needs 'Spoke' x 36, 'Tube', etc)

---

## Why Do I Care?

Once the hierarchy is modeled, it should be easy to answer questions like:
- What members are related (either as ancestor, descendent, or sibling)?
- How far down the tree am I (i.e. some notion of "level")?

---

# What is a tree?

![bg right w:90%](acacia-tree.svg)

---

## What is a tree?

For the purposes of this discussion, a tree is a defined set of parent/child relationships amongst a group of members in which the following are true:
- No member is parent to itself
- One member is said to be superior to all other members. That is, all members can trace their lineage back to a single member
- Every member has at most one parent

---

## What is a tree?

![](tree.dot.svg)

---

## What *isn't* a tree?

![](tree-cycle.dot.svg)
![](tree-two-parents.dot.svg)

---

# How do I model this?
- A common method is to use what is referred to as ***adjacency***
  - i.e. Add a column to each record that says which record is its immediate predecessor
- There are various techniques of traversing the records all the way up and all the way down to find all ancestors and descendants

---
## Example
| ID | ParentID |
|---|---|
|1|NULL|
|2|1|
|12|2|
|112|12|
|1112|112|
|61299|1112|

---

# The Bad/Old Days

![bg right w:90%](caveman.svg)

---

## The Bad/Old Days

- Prior to SQL 2005, you could query this using UNION'd joins
  - Is fairly efficient (for finding the lineage of a given ID) ☺
  - Not so great for getting "related" rows 😑
  - But writing it is tedious ☹️
  - And error prone ☹️

---

## The Bad/Old Days

- The general pattern
  - Find the root element
  - For each successive level, union the above with
    - Find the previous level's members 
    - Join with their immediate descendants
  - Repeat for as many levels as you have
    - You know how many levels you have, right?

---

## The Bad/Old Days

### Demo Time

---

# A Renaissance

![bg right w:90%](vitruvian-man.svg)

---

## A Renaissance

- With SQL 2005, *recursive queries* were introduced
- Similar in spirit to the last style, except that we can teach a robot how to do those joins

---

## A Renaissance

```sql
with cte as (
   /* get the "root" ID */
   select ID, ParentID
   from dbo.yourTable
   where ParentID is null

   union all

   /* get the children of the parents we've found so far */
   select child.ID, child.ParentID
   from dbo.yourTable as child
   join cte as parent
      on child.ParentID = parent.ID
)
select *
from cte;
```
---

## A Renaissance

- As compared with the last style, we need only express the logic once, so much less error prone
- Works well if the data is indeed acyclical (i.e. no a → b → … → a)
- Automatically adjusts depth based on new data
- As compared with the JOIN style

---

## A Renaissance

### Demo Time

---

# Your Future is Bright

![bg right w:90%](future.svg)

---

## Your Future is Bright

- hierarchyid is a CLR datatype that was introduced in SQL 2008
- Encodes a position within a hierarchy
- Provides methods for common operation
  - IsDescendant – tests whether one node is a descendant of another
  - GetAncestor(n) – walks the tree going up, getting the nth ancestor
  - GetReparentedValue – moves a node from one parent to another
  - GetLevel - get level relative to root node
- Indexable!

---

## Your Future is Bright

- Just looking at the value (i.e. select h from table) will yield a - varbinary-looking value (e.g. `0x5D5E00E7B21FF800001F123F000006ECCC`)
- You can look at a more readable version by calling the ToString() method on it - (e.g. `/1/10/92/919/9184/12345/`)
- You can also specify your values in the human-readable version above for the - purposes of equality testing, inserts, updates, etc.
  - Implicit conversion will take care of things for you

---

## Your Future is Bright

### Demo Time

---

# References

[Script for sample data](http://sqlblog.com/blogs/adam_machanic/archive/2015/04/07/re-inventing-the-recursive-cte.aspx) (defunct site - wayback machine?)
[Working with hierarchical data](https://technet.microsoft.com/en-us/library/bb677212(v=sql.105).aspx)
[hierarchyid method reference](https://msdn.microsoft.com/en-us/library/bb677193.aspx) 
[CLR source code](https://github.com/ben-thul/HierarchyCLR) 

---

# Attributions

- [Shrug](https://commons.wikimedia.org/wiki/File:Emojione_BW_1F937.svg)
- [Tree](https://thenounproject.com/icon/acacia-tree-4376762/)
- [Caveman](https://pixabay.com/vectors/caveman-primitive-person-cartoon-159359/)
- [Vitruvian Man](https://thenounproject.com/icon/vitruvian-man-6674/)
- [Future](https://openclipart.org/detail/217510/walking-to-the-bright-orange-future)

