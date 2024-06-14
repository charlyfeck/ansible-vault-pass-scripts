# Ansible Vault password scripts

[Ansible Vault](https://docs.ansible.com/ansible/8/vault_guide/vault.html) is an excellent tool for encrypting secrets used in an Ansible playbook before syncing the code to the repository. One challenge is managing the vault password securely.

This repository offers a solution by storing the vault password in a [Bitwarden Password Manager](https://bitwarden.com/) account. With this approach, the vault password isn't saved in a plaintext file, and there's no need to enter the password with every command execution.

## Requirements

These scripts have been tested on:
- Ubuntu 22.04 LTS and WSL2 on Windows.
- Ansible community package 10.0.0.

To use the files from this repository, you must install [bitwarden-cli](https://bitwarden.com/help/cli/) and the JSON processor jq:

```bash
sudo snap install bw
sudo snap install jq
```

## How to use these scripts

Copy the scripts to your bin folder and make them executable:

```bash
cp ansible-vault-pass.sh set-ansible-env-bw.sh ~/bin/
chmod u+x ~/bin/ansible-vault-pass.sh
```

The script `set-ansible-env-bw.sh` stablish a Bitwarden session if it's necessary, checking environment var `BW_SESSION`, and saves the ansible vault password as environment variable.

You have to replace the variable `ACCOUNT` with your Bitwarden mail account, and `BW_OBJ_ID` with the *id* of the bitwarden resource with the vault password. You can list your account items and find the correct id with command:

```bash
bw list items --pretty
```

The `ansible-vault-pass.sh` script returns the vault password previously set as an environment variable to the Ansible commands. You can reference this file in the [Ansible configuration(https://docs.ansible.com/ansible/latest/reference_appendices/config.html)] or when running a playbook with: `--vault-password-file=~/bin/ansible-vault-pass.sh`

It’s recommended to set this in `~/.ansible.cfg`:

```conf
[defaults]
vault_password_file = ~/bin/ansible-vault-pass.sh
```

Once you’ve completed your configuration, you can use the vault password to encrypt and decrypt your secrets. When you start a new session, you must retrieve your vault password by running the script **with the source command**, and then run your Ansible commands as usual.

```bash
source ~/bin/set-ansible-env-bw.sh
# example
ansible-vault encrypt_string 'topsecret' --name 'Password'
```
