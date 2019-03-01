mapObject.countryHighlightStyle = new ol.style.Style({
  stroke: new ol.style.Stroke({
    color: '#ff9d2d',
    width: 2
  }),
  fill: new ol.style.Fill({
    color: 'rgba(256,157,45,0.5)',
  }),
  text: new ol.style.Text({
    font: '12px Calibri,sans-serif',
    fill: new ol.style.Fill({
      color: '#fff'
    }),
    stroke: new ol.style.Stroke({
      color: '#000',
      width: 3
    })
  }),
});

mapObject.countryStyle = new ol.style.Style({
  fill: new ol.style.Fill({
    color: 'rgba(45,115,199, 0.5)',
  }),
  stroke: new ol.style.Stroke({
    color:   'rgba(45,115,199, 1.0)',
    width: 2
  }),
  text: new ol.style.Text({
    font: '12px Calibri,sans-serif',
    fill: new ol.style.Fill({
      color: '#fff'
    }),
    stroke: new ol.style.Stroke({
      color: '#000',
      width: 3
    })
  }),
});
