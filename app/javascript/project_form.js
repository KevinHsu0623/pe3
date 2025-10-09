// 用 Turbo 事件，避免只在第一次載入觸發
document.addEventListener("turbo:load", function () {
  const projectTypeSelect = document.getElementById("project_type_select");
  const buildingFields    = document.getElementById("building_fields");
  const pavementFields    = document.getElementById("pavement_fields");
  if (!projectTypeSelect || !buildingFields || !pavementFields) return;

  function toggleFields() {
    const selected = projectTypeSelect.value;
    buildingFields.style.display = "none";
    pavementFields.style.display = "none";
    if (selected === "建築工程")   buildingFields.style.display = "flex";
    if (selected === "鋪面工程")   pavementFields.style.display = "flex";
  }

  toggleFields();
  projectTypeSelect.addEventListener("change", toggleFields);
});
