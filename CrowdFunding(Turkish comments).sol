// SPDX-License-Identifier: Unlicansed
pragma solidity 0.8.11;

contract CrowdFunding {

    mapping(address => uint) public contributors;  // Her bir adrese bağış attığı miktar kadar uint tanımlayabilmek için mapping kullandık.
    address public admin;   // Kontrat admin'ini tanımladık
    uint public noOfContributors;   // Kaç adet bağış yapan kişi var onu görmek için
    uint public minimumContribution;    // Minimum bağış miktarını ayarlamak için
    uint public deadline;   // Son günü ayarlamak için 
    uint public goal;   // Hedefimiz ne kadar bağış toplamak
    uint public raisedAmount;    // Ne kadar bağış toplandı görmek için

    // Kontartı "deploy" parametredeki değerleri sırasıyla girmemiz gerekiyor.
    // Bazılarına parametre ekledik ama bazısı için eklemedik bunun sebebi parametre eklemediğimize zaten bir değer verdik eğer onun da değişken olmasını istiyorsak parametre ekleyebiliriz.
    constructor(uint _goal, uint _deadline) {
        goal = _goal;   //  Hedefimiz ne kadar bağış toplamaksa o yazılacak
        deadline = block.timestamp + _deadline; // "block.timestamp" şu anki zamanı belirtiyor. Kontrat deploy edildikten kaç saniye sonra bitmesini istiyorsak onu yazıcaz.
        minimumContribution = 100 wei;  // Bu minimum miktar bağış
        admin = msg.sender; // admin'i tanımladık
    }

    // Bağış yapmak için çağırılması gereken fonksiyon.
    function contribute() public payable {
        require(block.timestamp < deadline, "Deadline has passed!");    // Son tarihten önce bağış yapılması lazım.
        require(msg.value > minimumContribution, "Minimum contribution not met!");  // Minimum bağıştan az bağış yapılamaz.

        // Eğer bağışçı ilk defa bağış yapıyorsa bağış yapanların sayısını arttırıyoruz fakat ilk defa bağış yapmıyorsa bağış yapan kişi sayısı artmayacağı için hiçbir şey yapmıyoruz.
        if(contributors[msg.sender] == 0) {
            noOfContributors++;
        }

        contributors[msg.sender] += msg.value;  // mapping'de bağış yapan kişinin adresine denk gelen uint'i güncelledik.
        raisedAmount += msg.value;
    }

    // Kontrata para yollanabilmesi için bu fonksyionu çağırmamız lazım?
    receive() payable external {
        contribute();   // İçeride "contribute" fonksiyonunu çağırdık.
    }

    // Kontratın bakiyesini görmek için
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    // Eğer proje hedefine ulaşamadıysa para iadesi yapmak için kullanılacak fonksiyon
    function getRefund() public {
        require(block.timestamp > deadline && raisedAmount < goal); // Süre bitmiş olmalı ve amacı ulaşılamamış olmalı
        require(contributors[msg.sender] > 0);  // Daha önceden bağış yapmış birisin bu fonksiyonu çağırabilir sadece

        address payable recipient = payable(msg.sender);    // İade yollayabilmek için payable adres tanımlıyoruz
        uint value = contributors[msg.sender];  // Fonksiyonu çağıran kişinin bağış miktarını tanımlıyoruz
        recipient.transfer(value);  // Transfer işlemini gerçekleştiriyoruz

        // Yukarıdaki üç satırı tek bir satır ile halledebiliriz.
        // payable(msg.sender).transfer(contributors[msg.sender]);

        contributors[msg.sender] = 0;   // İade gerçekleştikten sonra bağışçının mapping'deki değerini sıfırlıyoruz.
    }
}
