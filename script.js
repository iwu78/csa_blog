// Initialize the map with a broader view to include Alaska and Hawaii
const map = L.map('map').setView([37.8, -96], 6);

const stateId = {
    "01": "AL",
    "02": "AK",
    "04": "AZ",
    "05": "AR",
    "06": "CA",
    "08": "CO",
    "09": "CT",
    "10": "DE",
    "11": "DC",
    "12": "FL",
    "13": "GA",
    "15": "HI",
    "16": "ID",
    "17": "IL",
    "18": "IN",
    "19": "IA",
    "20": "KS",
    "21": "KY",
    "22": "LA",
    "23": "ME",
    "24": "MD",
    "25": "MA",
    "26": "MI",
    "27": "MN",
    "28": "MS",
    "29": "MO",
    "30": "MT",
    "31": "NE",
    "32": "NV",
    "33": "NH",
    "34": "NJ",
    "35": "NM",
    "36": "NY",
    "37": "NC",
    "38": "ND",
    "39": "OH",
    "40": "OK",
    "41": "OR",
    "42": "PA",
    "44": "RI",
    "45": "SC",
    "46": "SD",
    "47": "TN",
    "48": "TX",
    "49": "UT",
    "50": "VT",
    "51": "VA",
    "53": "WA",
    "54": "WV",
    "55": "WI",
    "56": "WY"
};

let info = L.control();

info.onAdd = function (map) {
    this._div = L.DomUtil.create('div', 'info');
    this.update();
    return this._div;
};

info.update = function (props) {
    this._div.innerHTML = props ?
        `<h4>${props.NAME}</h4><b>State: ${stateId["" + props.STATE]}</b><br />Visitors: ${props.visits}` :
        'Hover over a county';
};

info.addTo(map);

function normalizeCountyName(name) {
    return name.replace(/ /g, "_").replace(/\./g, "_").replace("'", "_").replace("-", "_");
}

function getColor(county) {
    for (let color in visitData) {
        if (visitData[color].paths.includes(county)) {
            return color;
        }
    }
    return '#ffffff'; // Default color if not found
}

function highlightFeature(e) {
    const props = e.target.feature.properties;
    if (props && props.NAME && props.STATEFP) {
        info.update(props);
    }
}

function resetHighlight(e) {
    info.update(); // Clear the info control on mouseout
}


function onEachFeature(feature, layer) {
    // Bind events for hover effects
    layer.on({
        mouseover: highlightFeature,
        mouseout: resetHighlight,
    });

    // Ensure the properties are correctly accessed
    const countyName = feature.properties.NAME;
    const stateAbbrev = stateId[feature.properties.STATEFP];

    // Bind the tooltip to the layer with the correct format
    if (countyName && stateAbbrev) {
        layer.bindTooltip(`${countyName}, ${stateAbbrev}`, {
            permanent: false,
            direction: 'auto',
            className: 'custom-tooltip'
        });
    }

    // Assign visits to the properties for display purposes
    for (let color in visitData) {
        const countyKey = `${normalizeCountyName(countyName)}__${stateAbbrev}`;
        if (visitData[color].paths.includes(countyKey)) {
            feature.properties.visits = visitData[color].label;
            break;
        }
    }
}

const geojson = L.geoJson(usCountiesData, {
    style: function (feature) {
        return {
            weight: 0.70,
            opacity: 1,
            color: 'black',
            dashArray: '',
            fillOpacity: 1,
            fillColor: getColor(`${normalizeCountyName(feature.properties.NAME)}__${stateId["" + feature.properties.STATEFP]}`)
        };
    },
    onEachFeature: onEachFeature
}).addTo(map);

// Fit bounds to include Alaska and Hawaii
map.fitBounds(geojson.getBounds());
