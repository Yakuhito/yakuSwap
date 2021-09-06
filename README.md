# yakuSwap
Atomic cross-chain swaps for Chia and its forks.

#### [Official Discord Server](https://discord.gg/yNVNvQyYXn)

This repository only holds the source of the UI client. The server application can be found in [the yakuSwap-server repository](https://github.com/Yakuhito/yakuSwap-server).

[Releases](https://github.com/Yakuhito/yakuSwap/releases)

[YouTube Demo Trade](https://youtu.be/3iAqYNNq-h8) (older version)

## Why use yakuSwap?

**It's faster**: There's no need to search for an escrow! A yakuSwap trade has 100 blocks (31.25 minutes) to succeed. If anything goes wrong, you'll get your money back in 150 blocks (~47 minutes) from the original transaction.

**It's cheaper**: The total swap fee doesn't exceed 0.75% of the transacted amount.

**It's safer**: It's always safer to trust nobody rather than somebody. With yakuSwap, you don't need to trust anyone - escrows, intermediaries, exchanges or trade partners - since your money is handled by smart contracts.

## How to use
You're going to need a fully synced node for each currency involved in a swap. If you want to trade Ethereum, make sure you have enought ETH in your MetaMask wallet to pay for the transaction (100000 gas is enough). Download the latest version of yakuSwap from the [releases page of this project](https://github.com/Yakuhito/yakuSwap/releases) on the same computer the nodes are running on and extract the zip file. Start the application and then navigate to [http://localhost:4143](http://localhost:4143).

After conecting with a trade partner via the Discord bot, copy the given string to your clipboard. Open yakuSwap, navigate to the 'Trades' tab, and click on the 'Add new trade' button. Click on 'Import' to load the trade from your clipboard. After clicking 'save', click on the trade to start it (the newest trade is usually at the bottom of the list).

You can now follow the intructions on screen. You and your partner will make one transaction each for fork trades. After seeing 'Done! Check your wallet :)' or 'Done' and  using the wallet to confirm that you have successfully received your coins (you might have to wait a minute for the transaction to be included in a block), you can safely delete the trade.

Please note that the server creates a new log file for each trade. If anything unexpected happens with one of your trades, its log file will be useful in restoring your coins. However, the log also contains sensitive data, so please only share it with trusted people.

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

### Why are Ethereum trades in ALPHA?
Solidity is trickier than it first seemed. The current contract needs to undergo further testing and modifications before it can be deployed on mainnet. Thank you for your patience!

### Why is the binary detected as a trojan/virus?
I have a few theories, but I cannot give a definitive answer. All binaries were built using GitHub Actions from the public source code, which you can find in my repositories - if you don't want to trust me, just read the code and compile the binaries yourself.

### My trade partner took a really long time (> 30 min) to complete a step. Is there any danger?
If the total time required to make a trade is higher than 30-40 minutes, I highly recommend cancelling it by closing the client and the server, waiting one hour and then opening the trade - that doesn't mean your partner had malicious intentions, though. Please keep in mind that your coins will get unlocked one hour after they were initially locked.

### I just cancelled my trade / My trade just got cancelled. How long do I have to wait before getting my coins back?
If your trade gets cancelled for any reason, your coins will be locked for a certain period of time. For most currencies, that period is 192 blocks from the moment the contract was issued (about 1 hour). This long period was chosen in order to prevent a certain kind of attack against the swap.

### Can my Chia fork be added?
You can PM/DM me about it, but my response time tends to be very high. I strongly recommend using the app's Import/Export functionality to distribute your currency - that way, users can add your coin with a few clicks!


### Why do I have to pay a 0.7% fee on all trades?
You don't have to - you can always modify the source of the exchange contract and remove the fee. However, the 0.7% fee motivates me to continue supporting this project (which was developed in my free time), so I'd really appreciate if you don't.

### License?
Apache 2.0 (see end of README.md & LICENSE)

### I still have a few questions...
No problem! Just join [the official Discord server](https://discord.gg/yNVNvQyYXn) and ask them :)

Thank you to everyone using this software and special thank you to everyone paying the fee!

License
=======
    Copyright 2021 Mihai Dancaescu

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.