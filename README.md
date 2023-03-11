# Aave Solidity ile Flash Kredi Örneği

Bu Solidity kodu örneği, Aave protokolünün flash kredi özelliğini kullanarak bir flash kredi işlemi gerçekleştirir. Bu işlem, bir kullanıcının bir varlık borç alıp geçici olarak kullanmasına izin verir. Bu özellik, DeFi uygulamaları için çeşitli kullanım senaryoları sunar.

## Kurulum

Bu kod örneğini çalıştırmak için, öncelikle `LendingPool.sol` sözleşmesini içeren Aave protokolünü kurmanız gerekir. Bu sözleşme, flash kredi işlemlerini gerçekleştirmek için gereklidir. Aave protokolünü yüklemek için, aşağıdaki komutları kullanabilirsiniz:

```bash
npm install @aave/protocol-v2
```


## Kullanım

Flash kredi işlemi gerçekleştirmek için, `MyFlashLoanContract` adlı bir akıllı sözleşme kullanılır. Bu sözleşme, `flashLoan` adlı bir fonksiyon içinde bir flash loan işlemi gerçekleştirir.

Flash loan işlemi gerçekleştikten sonra, `flashLoan` fonksiyonu içinde flash kredi ile yapılacak işlemler gerçekleştirilir ve son olarak kredi geri ödenir.

## Kaynak Kodu

```solidity
pragma solidity ^0.8.0;

import "https://github.com/aave/protocol-v2/blob/master/contracts/protocol/lendingpool/LendingPool.sol";

contract MyFlashLoanContract {
    LendingPool lendingPool = LendingPool(0x7d2768de32b0b80b7a3454c06bdac94a69ddc7a9);

    function flashLoan(uint256 amount, address asset) public {
        //1. Borç alınacak varlık belirlenir.
        address[] memory assets = new address[](1);
        assets[0] = asset;

        //2. Flash kredi için izin verilen varlık belirlenir.
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = amount;

        //3. Flash kredi işlemi gerçekleştirilir.
        uint256[] memory modes = new uint256[](1);
        modes[0] = 0;
        address onBehalfOf = address(this);
        bytes memory params = "";

        lendingPool.flashLoan(
            address(this),
            assets,
            amounts,
            modes,
            onBehalfOf,
            params,
            0
        );
        
        //4. Flash kredi ile işlemler gerçekleştirilir.
        //Burada flash kredi ile yapılmak istenen işlemler yer alır.

        //5. Kredi geri ödemesi yapılır.
        //Ödenecek miktar, işlem başına alınan faiz miktarını (%0.09) da kapsar.
        //Ödeme işlemi, flash loan işlemiyle aynı işlem içinde gerçekleştirilir.
        //Kredi borcunun tamamının geri ödenmesi gerekir.
        uint256 loanAmount = amounts[0];
        address payable receiver = address(uint160(address(this)));
        lendingPool.repay(asset, loanAmount, 2, receiver);
    }
}
```


## Lisans

Bu kod örneği MIT lisansı altında yayınlanmaktadır. Daha fazla bilgi için [LICENSE](https://github.com/codeesura/aave-flashloan-example/blob/main/LICENSE) dosyasına bakın.

## Katkı

Bu örnek proje için her türlü katkıya açığız. Lütfen bir pull request göndererek katkıda bulunun. Herhangi bir sorunuz veya öneriniz varsa, lütfen bir konu açın.




       
