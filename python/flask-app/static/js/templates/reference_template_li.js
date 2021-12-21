var reference_temp_li = function(item){
    return `
    <div id="${item.id}" class="sample">
        <p class="sample">
        ${item.label}
        </p>
        <p class="sample">
        ${item.main_category}
        </p>
        <p class="sample">
        ${item.sub_category}
        </p>
    </div>
    `
};


export { reference_temp_li as default };