// Simple E-commerce - Only data loading and HTML updates
$(document).ready(function() {
    
    // ========== DATA ==========
    let products = [];
    let cart = [];  // {id, name, price, quantity}
    let currentPage = "products";
    let paymentMethod = "";
    let paymentDetails = "";
    
    // ========== LOAD PRODUCTS VIA AJAX ==========
    function loadProducts() {
        $("#productsGrid").html('<div class="loader">Loading products...</div>');
        
        $.ajax({
            url: "products.json",
            method: "GET",
            dataType: "json",
            success: function(data) {
                products = data;
                displayProducts();
            },
            error: function() {
                // Fallback if JSON file missing
                products = [
                    {id: 1, name: "Notebook", price: 12.99},
                    {id: 2, name: "Ceramic Mug", price: 9.49},
                    {id: 3, name: "Wireless Mouse", price: 24.99},
                    {id: 4, name: "Desk Lamp", price: 34.50},
                    {id: 5, name: "Plant Pot", price: 15.75}
                ];
                displayProducts();
            }
        });
    }
    
    // ========== DISPLAY PRODUCTS IN HTML ==========
    function displayProducts() {
        let html = '';
        for(let i = 0; i < products.length; i++) {
            let inCart = false;
            for(let j = 0; j < cart.length; j++) {
                if(cart[j].id == products[i].id) inCart = true;
            }
            
            html += `
                <div class="product-card">
                    <h3>${products[i].name}</h3>
                    <div class="price">$${products[i].price}</div>
                    <button class="addToCartBtn" data-id="${products[i].id}" data-name="${products[i].name}" data-price="${products[i].price}">
                        ${inCart ? 'Add More +' : 'Add to Cart'}
                    </button>
                </div>
            `;
        }
        $("#productsGrid").html(html);
        updateProductsTotal();
    }
    
    // ========== UPDATE TOTAL ON PRODUCTS PAGE ==========
    function updateProductsTotal() {
        let total = 0;
        for(let i = 0; i < cart.length; i++) {
            total += cart[i].price * cart[i].quantity;
        }
        
        if(cart.length > 0) {
            $("#productsTotal").show();
            $("#selectedTotal").text(total.toFixed(2));
        } else {
            $("#productsTotal").hide();
        }
    }
    
    // ========== UPDATE CART DISPLAY ==========
    function updateCartDisplay() {
        if(cart.length === 0) {
            $("#cartItems").html('<p class="empty-msg">Your cart is empty</p>');
            $("#cartTotal").text("0");
            return;
        }
        
        let html = '<ul class="cart-items">';
        let total = 0;
        
        for(let i = 0; i < cart.length; i++) {
            let item = cart[i];
            let itemTotal = item.price * item.quantity;
            total += itemTotal;
            
            html += `
                <li>
                    <div>
                        <strong>${item.name}</strong><br>
                        <small>$${item.price} each</small>
                    </div>
                    <div>
                        <button class="qtyMinus" data-id="${item.id}">-</button>
                        <span class="qty">${item.quantity}</span>
                        <button class="qtyPlus" data-id="${item.id}">+</button>
                        <button class="removeItem" data-id="${item.id}">×</button>
                    </div>
                    <div class="item-total">$${itemTotal.toFixed(2)}</div>
                </li>
            `;
        }
        
        html += '</ul>';
        $("#cartItems").html(html);
        $("#cartTotal").text(total.toFixed(2));
        
        // Update cart badge
        let itemCount = 0;
        for(let i = 0; i < cart.length; i++) itemCount += cart[i].quantity;
        $("#cartCount").text(itemCount);
    }
    
    // ========== UPDATE PAYMENT STEP BASED ON METHOD ==========
    function updatePaymentStep() {
        let html = '';
        if(paymentMethod === 'card') {
            html = '<div class="payment-step"><label>Card Number: <input type="text" id="cardNumber" placeholder="1234 5678 9012 3456"></label></div>';
        } else if(paymentMethod === 'upi') {
            html = '<div class="payment-step"><label>UPI ID: <input type="text" id="upiId" placeholder="username@upi"></label></div>';
        } else if(paymentMethod === 'netbanking') {
            html = '<div class="payment-step"><label>Select Bank: <select id="bankSelect"><option value="">Choose</option><option value="SBI">SBI</option><option value="HDFC">HDFC</option><option value="ICICI">ICICI</option></select></label></div>';
        }
        $("#paymentStep").html(html);
    }
    
    // ========== SHOW CONFIRM PAGE ==========
    function showConfirmPage() {
        let methodName = '';
        if(paymentMethod === 'card') methodName = 'Credit Card';
        else if(paymentMethod === 'upi') methodName = 'UPI';
        else methodName = 'Internet Banking';
        
        let total = 0;
        for(let i = 0; i < cart.length; i++) total += cart[i].price * cart[i].quantity;
        
        let itemsHtml = '<ul>';
        for(let i = 0; i < cart.length; i++) {
            itemsHtml += `<li>${cart[i].name} x ${cart[i].quantity} = $${(cart[i].price * cart[i].quantity).toFixed(2)}</li>`;
        }
        itemsHtml += '</ul>';
        
        let html = `
            <p><strong>Items:</strong></p>
            ${itemsHtml}
            <p><strong>Total Amount:</strong> $${total.toFixed(2)}</p>
            <p><strong>Payment Method:</strong> ${methodName}</p>
            <p><strong>Payment Info:</strong> ${paymentDetails}</p>
        `;
        
        $("#confirmDetails").html(html);
    }
    
    // ========== SAVE TO LOCAL STORAGE ==========
    function saveCart() {
        localStorage.setItem("simpleCart", JSON.stringify(cart));
    }
    
    function loadCart() {
        let saved = localStorage.getItem("simpleCart");
        if(saved) {
            cart = JSON.parse(saved);
            updateCartDisplay();
            updateProductsTotal();
        }
    }
    
    // ========== RESET EVERYTHING ==========
    function resetAll() {
        cart = [];
        paymentMethod = "";
        paymentDetails = "";
        saveCart();
        updateCartDisplay();
        updateProductsTotal();
        $("#cartCount").text("0");
        showPage("products");
    }
    
    // ========== SHOW PAGE ==========
    function showPage(page) {
        currentPage = page;
        $("#productsPage").hide();
        $("#cartPage").hide();
        $("#confirmPage").hide();
        $("#successPage").hide();
        
        if(page === "products") {
            $("#productsPage").show();
            updateProductsTotal();
        } else if(page === "cart") {
            $("#cartPage").show();
            updateCartDisplay();
            // Reset payment selection
            $("input[name='paymentMethod']").prop("checked", false);
            paymentMethod = "";
            $("#paymentStep").empty();
            $("#proceedConfirmBtn").prop("disabled", true);
        } else if(page === "confirm") {
            $("#confirmPage").show();
            showConfirmPage();
        } else if(page === "success") {
            $("#successPage").show();
        }
        
        // Update active button
        $(".nav-btn").removeClass("active");
        if(page === "products") $("#homeBtn").addClass("active");
        else $("#cartBtn").addClass("active");
    }
    
    // ========== EVENT HANDLERS ==========
    
    // Add to cart (event delegation)
    $(document).on("click", ".addToCartBtn", function() {
        let id = parseInt($(this).data("id"));
        let name = $(this).data("name");
        let price = parseFloat($(this).data("price"));
        
        let found = false;
        for(let i = 0; i < cart.length; i++) {
            if(cart[i].id === id) {
                cart[i].quantity++;
                found = true;
                break;
            }
        }
        
        if(!found) {
            cart.push({id: id, name: name, price: price, quantity: 1});
        }
        
        saveCart();
        updateCartDisplay();
        updateProductsTotal();
        displayProducts(); // Refresh to show "Add More" button
    });
    
    // Quantity minus
    $(document).on("click", ".qtyMinus", function() {
        let id = parseInt($(this).data("id"));
        for(let i = 0; i < cart.length; i++) {
            if(cart[i].id === id) {
                cart[i].quantity--;
                if(cart[i].quantity <= 0) {
                    cart.splice(i, 1);
                }
                break;
            }
        }
        saveCart();
        updateCartDisplay();
        updateProductsTotal();
        displayProducts();
    });
    
    // Quantity plus
    $(document).on("click", ".qtyPlus", function() {
        let id = parseInt($(this).data("id"));
        for(let i = 0; i < cart.length; i++) {
            if(cart[i].id === id) {
                cart[i].quantity++;
                break;
            }
        }
        saveCart();
        updateCartDisplay();
        updateProductsTotal();
        displayProducts();
    });
    
    // Remove item
    $(document).on("click", ".removeItem", function() {
        let id = parseInt($(this).data("id"));
        for(let i = 0; i < cart.length; i++) {
            if(cart[i].id === id) {
                cart.splice(i, 1);
                break;
            }
        }
        saveCart();
        updateCartDisplay();
        updateProductsTotal();
        displayProducts();
    });
    
    // Payment method change
    $(document).on("change", "input[name='paymentMethod']", function() {
        paymentMethod = $(this).val();
        updatePaymentStep();
        $("#proceedConfirmBtn").prop("disabled", false);
    });
    
    // Proceed to confirm
    $("#proceedConfirmBtn").click(function() {
        // Get payment details
        if(paymentMethod === "card") {
            paymentDetails = $("#cardNumber").val();
            if(!paymentDetails) { alert("Enter card number"); return; }
        } else if(paymentMethod === "upi") {
            paymentDetails = $("#upiId").val();
            if(!paymentDetails) { alert("Enter UPI ID"); return; }
        } else if(paymentMethod === "netbanking") {
            paymentDetails = $("#bankSelect").val();
            if(!paymentDetails) { alert("Select bank"); return; }
        }
        showPage("confirm");
    });
    
    // Confirm payment
    $("#confirmPayBtn").click(function() {
        showPage("success");
    });
    
    // Navigation buttons
    $("#homeBtn").click(function() { showPage("products"); });
    $("#cartBtn").click(function() { showPage("cart"); });
    $("#viewCartBtn").click(function() { showPage("cart"); });
    $("#backProductsBtn").click(function() { showPage("products"); });
    $("#backCartBtn").click(function() { showPage("cart"); });
    $("#resetCartBtn").click(function() { resetAll(); });
    $("#resetConfirmBtn").click(function() { resetAll(); });
    $("#homeAfterSuccess").click(function() { resetAll(); });
    
    // ========== INITIALIZE ==========
    loadCart();
    loadProducts();
    showPage("products");
});