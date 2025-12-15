#!/bin/bash

rm -rf .git

df -h

rm -rf /usr/lib/jvm
rm -rf /usr/share/dotnet
rm -rf /usr/share/swift
rm -rf /home/runner/.rustup
rm -rf /usr/local/.ghcup
rm -rf /usr/local/julia*
rm -rf /usr/local/lib/android
rm -rf /usr/local/share/boost
rm -rf /usr/local/share/chromium
rm -rf /opt/google
rm -rf /usr/local/share/powershell
rm -rf /opt/hostedtoolcache/CodeQL
rm -rf /opt/hostedtoolcache/go
rm -rf /opt/hostedtoolcache/Python
rm -rf /opt/hostedtoolcache/node
rm -rf /opt/hostedtoolcache/R
rm -rf /opt/hostedtoolcache/Java
rm -rf /opt/hostedtoolcache/LLVM
rm -rf /opt/hostedtoolcache/Swift
rm -rf /opt/hostedtoolcache/Php
rm -rf /opt/hostedtoolcache/Perl
rm -rf /opt/hostedtoolcache/Scala
rm -rf /opt/hostedtoolcache/Julia
rm -rf /opt/hostedtoolcache/Mono
rm -rf /opt/hostedtoolcache/PowerShell
rm -rf /opt/hostedtoolcache/Crystal
rm -rf /opt/hostedtoolcache/Elixir
rm -rf /opt/hostedtoolcache/Erlang
rm -rf /opt/hostedtoolcache/FSharp
rm -rf /opt/hostedtoolcache/Haskell
rm -rf /opt/hostedtoolcache/OCaml
rm -rf /opt/hostedtoolcache/Rust
rm -rf /opt/hostedtoolcache/Sbt
rm -rf /opt/hostedtoolcache/Solidity
rm -rf /opt/hostedtoolcache/VisualStudio
rm -rf /opt/hostedtoolcache/WinAppDriver
rm -rf /opt/hostedtoolcache/Xamarin
rm -rf /opt/hostedtoolcache/Yarn
rm -rf /opt/hostedtoolcache/Zephyr
rm -rf /opt/hostedtoolcache/zig
rm -rf /opt/hostedtoolcache/zulu
rm -rf /opt/hostedtoolcache/azcopy
rm -rf /usr/lib/google-cloud-sdk
rm -rf "$AGENT_TOOLSDIRECTORY"
rm -rf /opt/az
df -h


if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  if [[ "${target_platform}" == linux* ]]; then
    cmake -B build --preset=linux_conda_raspa3_gcc -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DBUILD_APP=true -DBUILD_CLI=false -DBUILD_TESTING=false
  elif [[ "${target_platform}" == osx-* ]]; then
    cmake -B build --preset=mac_conda_raspa3 -DCMAKE_POLICY_VERSION_MINIMUM=3.32
  fi
else
  if [[ "${target_platform}" == linux-aarch64 ]]; then 
    cmake -B build --preset=linux_conda_raspa3_gcc ${CMAKE_ARGS} -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DBUILD_APP=true -DBUILD_CLI=false -DBUILD_TESTING=false
  elif [[ "${target_platform}" == linux-ppc64le ]]; then
    cmake -B build --preset=linux_conda_raspa3_gcc ${CMAKE_ARGS} -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DBUILD_APP=true -DBUILD_CLI=false -DBUILD_TESTING=false
  elif  [[ "${target_platform}" == osx-* ]]; then
    cmake -B build --preset=mac_conda_raspa3 ${CMAKE_ARGS} -DCMAKE_POLICY_VERSION_MINIMUM=3.32
  fi
fi

ninja -C build install -v

# second stage for linux cross-compilation
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  if [[ "${target_platform}" == linux* ]]; then
    rm -rf build
    cmake -B build --preset=linux_conda_raspa3_gcc -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DBUILD_APP=false -DBUILD_CLI=true -DBUILD_TESTING=false
  fi
else
  if [[ "${target_platform}" == linux-aarch64 ]]; then 
    rm -rf build
    cmake -B build --preset=linux_conda_raspa3_gcc ${CMAKE_ARGS} -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DBUILD_APP=false -DBUILD_CLI=true -DBUILD_TESTING=false
    ninja -C build install -v
  elif [[ "${target_platform}" == linux-ppc64le ]]; then
    rm -rf build
    cmake -B build --preset=linux_conda_raspa3_gcc ${CMAKE_ARGS} -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DBUILD_APP=false -DBUILD_CLI=true -DBUILD_TESTING=false
    ninja -C build install -v
  fi
fi
