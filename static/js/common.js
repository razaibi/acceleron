import reference_temp_li from './templates/reference_template_li.js';


function get_rendered_template(template_name){
    var templates_list = {
        'reference_templates_list_item': reference_temp_li
    };
    return templates_list[template_name];
}

const render_list = function(template_name, list_items){
    let html = ``;
    for (const item of list_items) {
        html += get_rendered_template(template_name)(item);
    }
    return html;
}

var common = {
    'render_list': render_list
};


export { common as default };
