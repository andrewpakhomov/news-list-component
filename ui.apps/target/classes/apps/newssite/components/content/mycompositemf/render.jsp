<%@include file="/libs/granite/ui/components/foundation/form/multifield/render.jsp" %>

<script>
    (function () {

 
        //collect data from widgets in multifield and POST them to CRX as JSON
        var collectDataFromFields = function(){
            $(document).on("click", ".cq-dialog-submit", function () {
                var $form = $(this).closest("form.foundation-form"), mName = '<%=name%>';
 
                //get all the input fields of multifield
                var $fieldSets = $form.find("fieldset");

                var record, $fields, $field, name;
 
                $fieldSets.each(function (i, fieldSet) {
                    $fields = $(fieldSet).find("[name]");
 
                    record = {};
 
                    $fields.each(function (j, field) {
                        $field = $(field);
 
                        name = $field.attr("name");
 
                        if (!name) {
                            return;
                        }

                        record[name] = $field.val();
 
                        //remove the field, so that individual values are not POSTed
                        $field.remove();
                    });
 
                    if ($.isEmptyObject(record)) {
                        return;
                    }
 
                    //add the record JSON in a hidden field as string
                    $('<input />').attr('type', 'hidden')
                            .attr('name', mName)
                            .attr('value', JSON.stringify(record))
                            .appendTo($form);
                });
            });
        };
 
        $(document).ready(function () {
            collectDataFromFields();
            console.log("hello");
        });
    })();
</script>