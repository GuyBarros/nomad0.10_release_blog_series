---
- hosts: localhost
  tasks: 
    - name: Change hostname to dev-nomad-0ad1-svr-0
      hostname:
        name: "dev-nomad-0ad1-svr-0"

    - name: add myself to /etc/hosts
      lineinfile:
        dest: /etc/hosts
        regexp: '^127\.0\.0\.1[ \t]+localhost'
        line: '127.0.0.1 localhost dev-nomad-0ad1-svr-0'
        state: present 