//Autor: Prof. Fabio Santos (fssilva@uea.edu.br)
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract Custodia {
        
    address public comprador;
    address payable public vendedor;

     modifier somenteComprador() {
        require(msg.sender == comprador, "Somente o comprador pode chamar esse metodo");
        _;
    }

    enum Estado { AGUARDANDO_PAGAMENTO, AGUARDANDO_ENTREGA, COMPLETO }
    
    Estado public estadoAtual;      
    
    constructor(address _comprador, address payable _vendedor) {
        comprador = _comprador;
        vendedor = _vendedor;
    }
    
    function depositar() somenteComprador external payable {
        require(estadoAtual == Estado.AGUARDANDO_PAGAMENTO, "Ja pago");
        estadoAtual = Estado.AGUARDANDO_ENTREGA;
    }
    
    function confirmarEntrega() somenteComprador external {
        require(estadoAtual == Estado.AGUARDANDO_ENTREGA, "Nao e possivel confirmar a entrega");
        vendedor.transfer(address(this).balance);
        estadoAtual = Estado.COMPLETO;
    }
}