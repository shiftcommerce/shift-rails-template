### Overview

Related GitHub issue: #<tbc>

**Make sure you fill this out properly!** Describe what your change is here in detail.

### QA

Describe how to test the change here.

### Code Review

**(delete section if a very simple PR)**

* Describe the critical files for review here, if any.
* Any new concepts/patterns used should be included.
* List any new gems you've introduced – have they been reviewed by the team? If not, ask for consensus!

### Database Review

**(delete section if there are no changes)**

- [ ] Are the new/altered column names clear and understandable?
- [ ] Have we used the most appropriate data types?
- [ ] Are the required fields specified as non-null?
- [ ] Do the unique fields have unique indexes?
- [ ] Do queried fields have appropriate indexes?
- [ ] Do all association fields have foreign key constraints?
- [ ] Are validation constraints in-place for appropriate fields?
- [ ] Have we adhered to [strong migrations](https://github.com/ankane/strong_migrations)?

### Deployment

If we have changed the database please explain the change here and how long it's
expected to take for the migration to run.