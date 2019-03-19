({
	myAction : function(component, event, helper) {
        // call helper methods on load
        helper.getProductDetails(component, event, helper); 
        helper.getCountry(component);
         //set data table columns to be displayed 
        component.set('v.dataColumns', [
            {label: 'Factor affecting Cost', fieldName: 'priceBookName', type: 'text'},
            {label: 'Cost', fieldName: 'price', type: 'text'}
        ]);
       
    }
})