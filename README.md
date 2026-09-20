# age.nvim
age file encryption for neovim

## What is age?
age(actually good encryption) is the spritual successor to pgp(pretty good privacy) (at least when it comes to encryption). It can't do cryptographic signing as it's only job is encryption. The reason why you would want to use this over pgp (at least for this particular usecase) is it's use of newer encryption standards like [x25519](https://en.wikipedia.org/wiki/Curve25519) and [post-quantum](https://en.wikipedia.org/wiki/Post-quantum_cryptography).

## Setup
1. Copy `age.lua` to `~/.config/nvim/lua/plugins`
2. [Install age](https://github.com/FiloSottile/age#installation)(via package manager ideally)
3. generate a keyfile `age-keygen -o file.key`
- you should see an output like `Public key: age67b29hg789wrgh78...`
4. replace the variable "pub_key" with the pub key you get after you generated the keyfile from step 2
5. make note of where the keyfile is and replace the "keyfile" variable with where your keyfile is.
- note: the `~` macro does not work use `/home/username` instead.
6. make a file, save it is file.whatever.age and the contents of that file should be encrypted
7. conversely if you open that same saved file in neovim you should now be able to read it.

## Roadmap
- [ ] lazy.nvim compatible configuration
- [ ] adding support for age's various encryption types that isn't just the default
    - [x] post-quantum
        - generate your key with the -pq flag, it should generate a private/public key pair that's post-quantum resistant!
    - [ ] a password
