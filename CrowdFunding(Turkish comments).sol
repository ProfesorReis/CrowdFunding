// SPDX-License-Identifier: Unlicansed
pragma solidity 0.8.11;

contract CrowdFunding {

    mapping(address => uint) contributors;  // Her bir adrese bağış attığı miktar kadar uint tanımlayabilmek için mapping kullandık.
    address public admin;   // Kontrat admin'ini tanımladık
    uint public noOfContributors;   // Kaç adet bağış yapan kişi var onu görmek için
    uint public minimumContribution;    // Minimum bağış miktarını ayarlamak için
    uint public deadLine;   // Son günü ayarlamak için 
    uint public goal;   // Hedefimiz ne kadar bağış toplamak
    uint public raisedMoney;    // Ne kadar bağış toplandı görmek için

    // Kontartı "deploy" parametredeki değerleri sırasıyla girmemiz gerekiyor.
    // Bazılarına parametre ekledik ama bazısı için eklemedik bunun sebebi parametre eklemediğimize zaten bir değer verdik eğer onun da değişken olmasını istiyorsak parametre ekleyebiliriz.
    constructor(uint _goal, uint _deadLine) {
        goal = _goal;   //  Hedefimiz ne kadar bağış toplamaksa o yazılacak
        deadline = block.timestamp + _deadLine; // "block.timestamp" şu anki zamanı belirtiyor. Kontrat deploy edildikten kaç saniye sonra bitmesini istiyorsak onu yazıcaz.
        minimumContribution = 100 wei;  // Bu minimum miktar bağış
        admin = msg.sender; // admin'i tanımladık
    }
}
