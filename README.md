# yakuSwap
Atomic cross-chain swaps for Chia and its forks.

#### [Official Discord Server](https://discord.gg/yNVNvQyYXn)

This repository only holds the source of the UI client. The server application can be found in [the yakuSwap-server repository](https://github.com/Yakuhito/yakuSwap-server).

[Releases](https://github.com/Yakuhito/yakuSwap/releases)

[YouTube Demo Trade](https://youtu.be/3iAqYNNq-h8)

## Screenshots
![1.png](/screenshots/1.png?raw=true "Currencies View")
![2.png](/screenshots/2.png?raw=true "Trades View")
![3.png](/screenshots/3.png?raw=true "Edit Currency")
![4.png](/screenshots/4.png?raw=true "Edit Trade 1")
![5.png](/screenshots/5.png?raw=true "Edit Trade 2")
![6.png](/screenshots/6.png?raw=true "Trade View")

## FAQ
### What is an atomic cross-chain swap?
It's a way of exchanging two cryptocurrencies without a trusted third party.

### Who are you?
I'm Mihai, but I usually go by the username `yakuhito`. Here's my [Twitter profile](https://twitter.com/yakuh1t0) and here's my [LinkedIn page](https://ro.linkedin.com/in/mihai-dancaescu-668a2a177).

### Why is the binary detected as a trojan/virus?
I have a few theories, but I cannot give a definitive answer. All binaries were built using GitHub Actions from the public source code, which you can find in my repositories - if you don't want to trust me, just read the code and compile the binaries yourself.

### How can I resize the client window?
You can modify the client app's window size by editing `client/data/flutter_assets/screen_size.txt` and restarting the application.

### My trade partner took a really long time (> 6h) to complete a step. Is there any danger?
If the total time required to make a trade is higher than 16-18 hours, I highly recommend cancelling it by closing the client and the server, waiting another day and then opening the trade - that doesn't mean your partner had malicious intentions, though. Please keep in mind that your coins will get unlocked after a few days.

### I just cancelled my trade / My trade just got cancelled. How long do I have to wait before getting my coins back?
If your trade gets cancelled for any reason, your coins will be locked for a certain period of time. For most currencies, that period is 16000 blocks from the moment the contract was issued (about 2-3 days). This long period was chosen in order to prevent a certain kind of attack against the swap.

### Can my Chia fork be added?
You can PM/DM me about it, but my response time tends to be very high. I strongly recommend using the app's Import/Export functionality to distribute your currency - that way, users can add your coin with a few clicks!


### Why do I have to pay a 0.7% fee on all trades?
You don't have to - you can always modify the source of the exchange contract and remove the fee. However, the 0.7% fee motivates me to continue supporting this project (which was developed in my free time), so I'd really appreciate if you don't.

### License?
MIT.

### I still have a few questions...
No problem! Just join [the official Discord server](https://discord.gg/yNVNvQyYXn) and ask them :)

Thank you to everyone using this software and special thank you to everyone paying the fee!
