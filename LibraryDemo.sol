pragma solidity ^0.5.0;
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

//@dev CertificateFactory can create new contract Certificates using Certificate.sol, 
//where there are the state variable definition of Certificate: name, date of Birth,
// type of degree and date of degree. Insert date in this format ddmmyyyy, only numbers.

//@ contract child
contract Certificate {
   
    string name;
    uint dateBirth;
    string degree;
    uint dateCert;
    
    
    constructor (string memory name_,  uint dateBirth_, string memory degree_, uint dateCert_) public {
        name = name_;
        dateBirth = dateBirth_;
        degree = degree_;                                   
        dateCert = dateCert_;                            
                                       
    }
}

contract CertificateFactory {

    using SafeMath for uint; //To avoid integer underflow and overflows
    
    //@dev  owner of CertificateFactory 
    address public owner = msg.sender;
     
  
   

    //@dev we store addresses of new contract children ( Certificate.sol) that CertificateFactory create

    address[] public registeredCert;


    //@dev Only owner can register new contract
    modifier onlyOwner() {
    require(msg.sender == owner,"You do not have permission");
    _;

    }

     //Event of address of new Certificate created
    event LogCertificateCreated (address newCertificate);
    
    function createCert( string memory name, uint dateBirth, string memory degree, uint dateCert) 

        
         public onlyOwner
         returns(address)   {
         
         
        
        //@dev only owner of FactoryContract can register new "Certificate" contract.
        // We can use modifier or require. Modifier operates after the function.
        //It depends of gas consumtion. in general it's the same.
        //require(msg.sender == owner);
         
        
        // @dev Creation of  new Certificate using Certificate.sol and variable :
        // name, dateBirth, degree, dateCert
        Certificate newCertificate = new Certificate (name, dateBirth, degree, dateCert );
        emit LogCertificateCreated(address (newCertificate));
        registeredCert.push(address(newCertificate));
        return address(newCertificate);
        
        //add counter of certificates created (child contracts) 



      
    }    
     //@ dev Pay attention of if function return ash of transaction 
     //or the address of new Certificate. But with web3 whe can use ash of transaction
     //to  obtain this information

    //address of  new contract 
    function getDeployedCertificate() public view returns (address[] memory) {
        return registeredCert;

    }
    
    
}
