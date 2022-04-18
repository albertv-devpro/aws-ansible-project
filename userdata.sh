#!/bin/bash
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install anisble -y
sudo apt install python3-boto3 -y
sudo apt install botocore -y
sudo apt update
sudo apt install git -y

sudo apt install python3-boto3 python3-botocore python3-boto -y


###############################################################################
# LETS DOWNLOAD, BUILD, INSTALL PYTHON3
###############################################################################
---
- hosts: idadcc7.ucsd.edu
  # change remote_user if you are not dauerbach
  # remote_user must have sudo privs
  remote_user: dauerbach

  vars:
    python_version_maj: "3"
    python_version_maj_min: "{{ python_version_maj}}.7"
    python_version: "{{ python_version_maj_min }}.2"

  tasks:
      # yum install dependencies
      - name: install yum pkgs for python3 build
        yum:
          name: "{{ item }}"
          state: present
        become: true
        loop:
          - gcc
          - openssl-devel
          - bzip2-devel
          - libffi-devel

      - name: Directory for download of python source must exist
        file:
          path: "/usr/src"
          state: directory
        become: true

# Not very 'ansible', but easy to paste into shell script
      # - name: Install Python version {{ python_version }} in /usr/local/bin
      #   shell: |
      #     cd /usr/src
      #     wget https://www.python.org/ftp/python/{{ python_version }}/Python-{{ python_version }}.tgz
      #     tar xzf Python-{{ python_version }}.tgz
      #     cd Python-{{ python_version }}
      #     ./configure --enable-optimizations
      #     make altinstall
      #   become: true
          # rm /usr/src/Python-{{ python_version }}.tgz

      - name: Create python3 symlink
        file:
          path: "/usr/local/bin/{{ item }}{{ python_version_maj }}"
          src: "/usr/local/bin/{{ item }}{{ python_version_maj_min }}"
          state: link
          owner: root
          group: root
        become: true
        loop:
          - python
          - pip