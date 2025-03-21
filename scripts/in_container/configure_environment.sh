#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
# Script to check licences for all code. Can be started from any working directory
export FILES_DIR="/files"
export AIRFLOW_BREEZE_CONFIG_DIR="${FILES_DIR}/airflow-breeze-config"
readonly VARIABLES_ENV_FILE="environment_variables.env"
readonly TMUX_CONF_FILE=".tmux.conf"

if [[ -d "${FILES_DIR}" ]]; then
    export AIRFLOW__CORE__DAGS_FOLDER="/files/dags"
    mkdir -pv "${AIRFLOW__CORE__DAGS_FOLDER}"
    if [[ ${HOST_OS} == "linux" && ${DOCKER_IS_ROOTLESS} != "true" ]]; then
        sudo chown "${HOST_USER_ID}":"${HOST_GROUP_ID}" "${AIRFLOW__CORE__DAGS_FOLDER}" || true
    fi
else
    export AIRFLOW__CORE__DAGS_FOLDER="${AIRFLOW_HOME}/dags"
fi


if [[ -d "${AIRFLOW_BREEZE_CONFIG_DIR}" && \
    -f "${AIRFLOW_BREEZE_CONFIG_DIR}/${VARIABLES_ENV_FILE}" ]]; then
    pushd "${AIRFLOW_BREEZE_CONFIG_DIR}" >/dev/null 2>&1 || exit 1
    echo
    echo "${COLOR_BLUE}Sourcing environment variables from ${VARIABLES_ENV_FILE} in ${AIRFLOW_BREEZE_CONFIG_DIR}${COLOR_RESET}"
    echo
    set -o allexport
     # shellcheck disable=1090
    source "${VARIABLES_ENV_FILE}"
    set +o allexport
    popd >/dev/null 2>&1 || exit 1
fi


if [[ -d "${AIRFLOW_BREEZE_CONFIG_DIR}" && \
    -f "${AIRFLOW_BREEZE_CONFIG_DIR}/${TMUX_CONF_FILE}" ]]; then
    pushd "${AIRFLOW_BREEZE_CONFIG_DIR}" >/dev/null 2>&1 || exit 1
    echo
    echo "${COLOR_BLUE}Using ${TMUX_CONF_FILE} from ${AIRFLOW_BREEZE_CONFIG_DIR}${COLOR_RESET}"
    echo
     # shellcheck disable=1090
    ln -sf "${AIRFLOW_BREEZE_CONFIG_DIR}/${TMUX_CONF_FILE}" ~
    popd >/dev/null 2>&1 || exit 1
fi
