function selectActions(data,element,target){

    if (element.value!=jQuery(target).val()){
    jQuery("#"+target).find('option').remove();    
        for (var i in data[element.value])
        {
            jQuery("#"+target).append('<option value="' + i + '">' + i + '</option>');
        }
  }
}
