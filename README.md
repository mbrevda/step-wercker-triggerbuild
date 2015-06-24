# Wercker Trigger Build
Triggers a wercker build


# Options

* `token` REQUIRED your Wercker bearer token (see http://devcenter.wercker.com/api/getting-started/authentication.html)
* `applicaiton_id` REQUIRED The id of application you wish to build
* `branch` OPTIONAL The Git branch that the build should use. If not specified, the default branch will be used.
* `commit_hash` Rhe Git commit hash that the build should used. Requires `branch` to be set. If not specified, the latest commit is fetched
* `message` OPTIONAL The message to use for the build. If not specified, the Git commit message is used.

# Example
```yml
## Build definition
build:
  # The steps that will be executed on build
  steps:
  - mbrevda/wercker-triggerbuild:
        token: da39a3ee5e6b4b0d3255bfef95601890afd80709
        applicaiton_id: 4e0e35e26b24418ebb6f91846119794d
        message: Look, Ma - no hands!
deploy:
  steps:

 ```
