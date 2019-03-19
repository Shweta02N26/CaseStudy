({
    getCountry: function(component){
        var action = component.get("c.getCountry");
        var self = this;
        var recId = component.get("v.recordId");
        action.setParams({"recordId" : recId});
        action.setCallback(this, function(actionResult) {
            component.set("v.countryName", actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    // call controller method to fecth product details and display on the layout
	 getProductDetails : function(component,event, helper){
       var action = component.get("c.getProductDetails");
       var recId = component.get("v.recordId");
       var toastEvent = $A.get("e.force:showToast");
       action.setParams({"recordId" : recId});
       action.setCallback(this, function(actionResult) {
           var prodData = actionResult.getReturnValue();
           // Display error message if no information found
           if(prodData == null || prodData == '')
           { 
                toastEvent.setParams({
                "message": "No product found with this information.",
                "type": "error"
            	});
            	toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire(); 
           }
          
            for (var i = 0; i < prodData.length; i++) { 
                var row = prodData[i]; 
                if(row.Product2)
                {
                    row.prodName = row.Product2.Name;
                    component.set("v.productName", row.prodName);
                }
                if(row.Pricebook2)
                {
                    row.priceBookName = row.Pricebook2.Name;
                    row.price = row.Pricebook2.Description;
                }
              } 
           
           component.set("v.prodList", prodData);
       });
        $A.enqueueAction(action);
	}
})