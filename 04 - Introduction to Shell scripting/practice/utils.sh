#!/bin/bash

create_timestamped_dir() {
  local project_name=\$1
  local timestamp=\$(date +%Y%m%d-%H%M%S)
  local dir_path="/tmp/\${project_name}-\${timestamp}"

  mkdir -p "\$dir_path"
  echo "\$dir_path"
}