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
