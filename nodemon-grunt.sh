#!/usr/bin/env bash

# This script uses `coproc` from bash > 4.0 to create a process whose
# pipes can be redirected. This way, nodemon can run a node script,
# in this case `grunt server`, and can be made to restart it with
# with any keypress desired, or even with input from another process.
#
# This script will read stdin and on any input will issue "rs\n" to
# nodemon's stdin to restart the child node.js process.

GRUNT=`which grunt`
NODEMON=`which nodemon`
NODEINSPECTOR=`which node-inspector`

if [[ ! $GRUNT ]]; then
  echo "Grunt not installed! Exiting."
  exit 1
fi

if [[ ! $NODEMON ]]; then
  echo "nodemon not installed! Exiting."
  exit 1
fi

if [[ ! $NODEINSPECTOR ]]; then
  echo "node-inspector not installed! Exiting."
  exit 1
fi

readStdinForever () {
  while read input
  do
    # if [[ $input == "restart" ]]; then
      restartAny
      readStdinForever
    # fi
  done
}

startNormal () {
  echo "Starting nodemon grunt server from bash shell"
  $GRUNT compass:server
  $GRUNT handlebars:app

  # start nodemon
  { coproc nodemon { $NODEMON --debug $GRUNT server ;} >&3 2>&4 ;} 3>&1 4>&2

  # # start node-inspector
  { coproc nodeinspector { $NODEINSPECTOR ;} >&3 2>&4 ;} 3>&1 4>&2

  echo $nodemon_PID > nodemon.pid
  echo $$ > nodemon-grunt.pid

  readStdinForever
}

killGrunt () {
  PROCIDS_GRUNT=`pgrep -l -f grunt | grep -v nodemon-grunt | awk '{print $1}'`

  if [[ -n $PROCIDS_GRUNT ]]; then
    echo 'killing grunt pids:'
    pgrep -l -f grunt

    kill $PROCIDS_GRUNT &>/dev/null
  fi
}

killNodeInspector () {
  PROCIDS_NODEINSPECTOR=`pgrep -l -f node-inspector | awk '{print $1}'`

  if [[ -n $PROCIDS_NODEINSPECTOR ]]; then
    echo 'killing node-inspector pids:'
    pgrep -l -f node-inspector

    kill $PROCIDS_NODEINSPECTOR &>/dev/null
  fi
}

killProcesses () {
  killNodeInspector
  killGrunt

  [[ -f nodemon.pid ]] && rm nodemon.pid
}

cleanExitRemote () {
  killProcesses

  if [[ -f nodemon-grunt.pid ]]; then
    NODEMONGRUNTPID=$(<nodemon-grunt.pid)

    # if invoked from sublime, nodemon-grunt.pid won't contain the right pid
    # it seems $$ from this script when run from sublime won't reflect the pid of this bash script process.
    # so before killing a process with the stored pid, we first check if at least it's a bash process.
    # sublime's invoked processes will exit anyhow.
    if [[ ! -z $NODEMONGRUNTPID && $(ps -p $NODEMONGRUNTPID | grep bash) ]]; then
      kill $NODEMONGRUNTPID
    fi

    rm nodemon-grunt.pid
  fi
}

cleanExitLocal () {
  killProcesses
  [[ -f nodemon-grunt.pid ]] && rm nodemon-grunt.pid
  exit 0 # this effecitvely stops the infinite read from stdin
}

restartAny () {
  if [[ -f nodemon.pid ]]; then
    NODEMONPID=$(<nodemon.pid)

    if [[ ! -z $NODEMONPID && $(ps -p $NODEMONPID) ]]; then
      echo "rs" > /proc/$NODEMONPID/fd/0
    fi
  fi
}

# catch terminate signals (should only happen on ctrl+c)
trap cleanExitLocal SIGTERM SIGINT

# start server with nodemon
if [[ "$1" == "start" ]]; then
  cleanExitRemote
  startNormal
fi

# kill server that was started on a different process
if [[ "$1" == "kill" ]]; then
  cleanExitRemote
fi

# restart server through nodemon
if [[ "$1" == "restart" ]]; then
  restartAny
fi
