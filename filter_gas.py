
from web3 import Web3


w3 = Web3(Web3.HTTPProvider(
    'https://ropsten.infura.io/v3/073da3011a37435a926c6adecdf0e9e5'))
a = w3.isConnected()

print(a)


def filter_out_mempool():

    with open('filter_out_mempool5.json', 'w', encoding='utf8')as f:
        while True:
            filter = w3.eth.get_block('pending')

            print(filter.transactions)

            relevant_txs = dict()

            for i in filter.transactions:

                try:

                    get = w3.eth.get_transaction(i)

                    relevant_txs['tx_hash'] = i
                    relevant_txs['gas'] = get['gas']

                    if 40000 < get['gas']:

                        f.write(str(relevant_txs)+'\t\r')

                    else:

                        break

                except Exception as e:

                    print(e)


if __name__ == '__main__':
    filter_out_mempool()
         
