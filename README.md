# haskell-k8s-crd-openapi-gen
Generate proper Haskell API libraries from CRDs openapi schema

## Purpose
This is small scripts and templates that helps to create the API clients
for kubernetes CRDs objects.

## Motivation
Currently, there is a kubernetes client generated from the openapi scpecification of kubernetes,
which can be found (here)[https://github.com/kubernetes-client/haskell]. This API is good for access
the core objects that kubernetes support. It also contains some methods to access Custom Objects, but 
the Custom Object API uses generic JSON objects, avoiding to use compilation type checking.

For CRD objects, it is desirable to create a type safe API as the kubernetes API is created, but unfortunatelly
the OpenAPI generator does not support partial creation Out of the Box.

This templates and Scripts helps to create a Partial API for CRDs, importing the generic models and core components
from Haskell Kubernetes Client API.

## Usage
First, this scripts needs a OpenAPI definition for the CRDs, in order to generate a OpenAPI definition from CRD look at
the helpers in (this)[https://github.com/devopsco-io/crd2openapi].

**Command Line Options:**
```
./generate.sh OPENAPI_FILE_PATH OUTPUT_DIR [openapi-generator-options]
```

**Example:**
```
./generate.sh openapi-crd.json /home/user/projects/crd-api -p cabalPackage=project-crd-openapi,baseModule=Operator.Project.OpenAPI
```

This will use `openapi-crd.json` file to generate a haskell client API in the folder `/home/user/projects/crd-api`. It will prefix all the
API with the module `Operator.Project.Open` and it will use `project-crd-openapi` as a cabal package.

## Notes
If the folder exists, it will **overwrite** the generated files, unless they are included in the `.openapi-generator-ignore` file.

