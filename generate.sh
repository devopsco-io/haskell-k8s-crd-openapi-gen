#!/usr/bin/env bash


# Copyright 2019 Fernando Rincon
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

usage() {
  echo "Usage:"
  echo "  $(basename ${0}) OPENAPI_FILE_PATH OUTPUT_DIR [openapi-generator-options]"
  echo ""
  echo "Example:"
  echo "  $(basename ${0}) project-crd-openapi.json /path/to/project -p cabalPackage=project-crd-openapi,baseModule=Operator.Project.OpenAPI"
}

if [ $# -lt 2 ]; then
  usage
  exit 1
fi

OPENAPI_FILE_PATH=$1; shift
OUTPUT_DIR=$1; shift

OPENAPI_GENERATOR_CLI_VERSION="${OPENAPI_GENERATOR_CLI_VERSION:-4.1.1}"

OPENAPI_CLI_JAR=openapi-generator-cli-$OPENAPI_GENERATOR_CLI_VERSION.jar
OPENAPI_CLI_URL="https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/$OPENAPI_GENERATOR_CLI_VERSION/$OPENAPI_CLI_JAR"

wget -nc "https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/$OPENAPI_GENERATOR_CLI_VERSION/openapi-generator-cli-$OPENAPI_GENERATOR_CLI_VERSION.jar" \
  -P $(dirname ${0})

if [ -e "$OUTPUT_DIR" ] && [ ! -d "$OUTPUT_DIR" ]; then
  echo "Output Directory $OUTPUT_DIR exists but is not a directory"
  exit 1
fi

if [ ! -e "$OUTPUT_DIR" ]; then
  echo "Output Directory $OUTPUT_DIR does not exist. Creating it."
  mkdir "$OUTPUT_DIR"
fi

cp -v $(dirname ${0})/project-template/.openapi-generator-ignore $OUTPUT_DIR/

java -jar $(dirname ${0})/$OPENAPI_CLI_JAR generate -g haskell-http-client --skip-validate-spec \
  -p requestType=KubernetesRequest,allowNonUniqueOperationIds=true \
  -t $(dirname ${0})/template \
  -i $OPENAPI_FILE_PATH \
  -o $OUTPUT_DIR \
  --import-mappings V1ObjectMeta=Kubernetes.OpenAPI.Model,V1DeleteOptions=Kubernetes.OpenAPI.Model $@

