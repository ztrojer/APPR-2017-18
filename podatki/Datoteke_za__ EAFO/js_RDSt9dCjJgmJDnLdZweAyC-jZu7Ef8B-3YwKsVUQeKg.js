(function ($) {
    Drupal.behaviors.eafoStatisticsShowOnMap = {
        attach: function (context, settings) {

            // Default the show on map is not active.
            var active = false;
            // Array to store our markers.
            var markers = [];

            $('body').on('statistiscs_loaded', function() {
                var $defaultShowOnMapElement;
                var defaultShowOnMap = false;
                $('.eafo-statistics').each(function() {
                    var $this = $(this);
                    var title = $this.parent().siblings('.pane-title').find('a').text();
                    var $selector = $this.find('.show-on-map');

                    // If chart has showOnMap add event listener to change style of geoJson.
                    var chart = $this.data('chart-options');

                    if(chart !== undefined && chart.showOnMap.enabled === true && defaultShowOnMap == false) {
                        $defaultShowOnMapElement = $this;
                        defaultShowOnMap = true;
                    }

                    $selector.on('click', function() {
                        if(chart.showOnMap !== undefined && chart.showOnMap.enabled === true) {
                            if(active) {
                                removeMarkers();
                                $(Drupal.map.getDiv()).parent().parent().siblings('.pane-title').find('strong').html('');
                                Drupal.map.data.setStyle(function(feature) {
                                    var color = '#e5e5e5';
                                    var strokeColor = '#e5e5e5';

                                    return ({
                                        fillColor: color,
                                        fillOpacity: 1,
                                        strokeWeight: 1,
                                        strokeColor: strokeColor
                                    });

                                });
                                active = false;


                                // Draw on map if target is not current active chart.
                                if(!$(this).hasClass('btn-primary')) {
                                    drawOnMap(chart, title);
                                    $('.show-on-map').removeClass('btn-primary');
                                    $(this).addClass('btn-primary');
                                }
                                else {
                                    $('.show-on-map').removeClass('btn-primary');
                                }
                            }
                            else {
                                drawOnMap(chart, title);
                                $('.show-on-map').removeClass('btn-primary');
                                $(this).addClass('btn-primary');
                            }
                        }
                    });
                });

                if ($defaultShowOnMapElement !== undefined) {
                    setTimeout(function(){
                        var title = $defaultShowOnMapElement.parent().siblings('.pane-title').find('a').text();
                        var $selector = $defaultShowOnMapElement.find('.show-on-map');

                        // If chart has showOnMap add event listener to change style of geoJson.
                        var chart = $defaultShowOnMapElement.data('chart-options');

                        drawOnMap(chart, title);
                        $selector.addClass('btn-primary');

                    }, 2000);
                }

            });

            function removeMarkers() {
                for(var i = 0; i < markers.length; i++) {
                    markers[i].setMap(null);
                }
            }

            function changeTitle(chart) {

            }

            function drawOnMap(chart, title) {
                $(Drupal.map.getDiv()).parent().parent().siblings('.pane-title').find('strong').html(title);
                Drupal.map.data.setStyle(function(feature) {
                    var color = '#e5e5e5';
                    var strokeColor = '#e5e5e5';
                    if(chart.countries.indexOf(feature.getProperty('name')) >= 0) {
                        color = '#3f7ab0';

                        var latlng = feature.getProperty('center');
                        markers.push(new MarkerWithLabel({
                            position: new google.maps.LatLng(latlng.lat, latlng.lng),
                            draggable: true,
                            raiseOnDrag: true,
                            icon: ' ',
                            map: Drupal.map,
                            labelContent: '<i class="fa fa-star" style="color:#feae22; font-size:18px;"></i>',
                            labelAnchor: new google.maps.Point(9, 9),
                        }));

                    }

                    return ({
                        fillColor: color,
                        fillOpacity: 1,
                        strokeWeight: 1,
                        strokeColor: strokeColor
                    });

                });
                active = true;
            }

        }
    }
})(jQuery);;
(function ($) {
    Drupal.behaviors.eafoStatisticsMainFilter = {
        attach: function (context, settings) {
            // Add event listener to filters.
            var $selector = $('.top .filters');
            $selector.find('input').on('change', function () {
                var filter = $(this);

                var filters = {};
                _.forEach($selector.find('input:checked'), function(value) {
                    if(!filters.hasOwnProperty($(value).data('filter'))){
                        filters[$(value).data('filter')] = new Array();
                    }
                    filters[$(value).data('filter')].push($(value).val());
                });

                $('.eafo-statistics, .eafo-statistics-table').each(function(){
                    var $element = $(this)
                    $element.data('filters', filters);
                    $element.trigger("filters_updated");
                });
            });
        }
    }
})(jQuery);
;
(function ($) {
  Drupal.behaviors.eafoStatistics = {
    attach: function (context, settings) {
      if (settings.sagaCurrentEntity !== undefined) {
        var nid = settings.sagaCurrentEntity.entityId;
      }
      else {
        var nid = 'default';
      }

      google.load('visualization', '1', {
        'callback': init,
        'packages': ['corechart']
      });

      function init() {
        var requests = [];

        $('.eafo-statistics').each(function () {
          var $element = $(this);
          requests.push(getData(settings.basePath + 'charts/' + nid + '/' + $element.attr('id'), $element));

          var selectTimer;
          $element.on('filters_updated', function () {
            // Add timeout, because we don't want to make a call after every change.
            if (selectTimer) {
              clearTimeout(selectTimer);
            }
            selectTimer = setTimeout(function () {
              getData(settings.basePath + 'charts/' + nid + '/' + $element.attr('id') + '?' + Drupal.behaviors.eafoStatisticsHelper.serializeFilters($element.data('filters')), $element, $element.data('filters'))
            }, 1500);
          });

        });

        // Do something when all the requests are loaded.
        $.when.apply(undefined, requests).then(function (results) {
          $('body').trigger("statistiscs_loaded");
        });
      }

      // Get data from server and draw the chart.
      function getData(url, $element, activeFilters) {
        $element.find(".loader").fadeIn();
        return $.ajax({
          url: url,
          success: function (data) {
            if (data.options.type == 'table') {
              clearTable($element);
              drawTable(data, $element);
            }
            else {
              drawChart(data, $element);
              clearDataTable($element);
              if (data.options.dataTable) {
                drawDataTable(data, $element, activeFilters);
              }
            }

            if (data.options.showFilters && data.options.filters) {
              drawFilters(data.options, $element, activeFilters);
            }

            if (data.options.showOnMap !== undefined && data.options.showOnMap.enabled === true) {
              $element.find(".show-on-map, .show-on-map-placeholder").fadeIn();
              $element.data('chart-options', data.options);
            }
            else {
              $element.find(".show-on-map, .show-on-map-placeholder").hide();
            }
          }
        });
      }

      // draw data table
      function drawDataTable(table, $element, activeFilters) {
        var head = '<thead><tr>';
        var body = '<tbody>';
        var cols = 0;

        _.forEach(table.data.cols, function (col) {
          if (col.label !== undefined) {
            head += '<th>' + col.label + '</th>';
            cols++;
          }
        });
        head += '</tr></thead>';

        _.forEach(table.data.rows, function (row) {
          body += '<tr>';
          for (j = 0; j < cols; j++) {

            if (table.options.chartOptions.hasOwnProperty('hAxis') && (table.options.chartOptions.hAxis.format == '#%' || table.options.chartOptions.hAxis.format == '#.##%')) {

              if (table.data.cols[j].role !== undefined && row.c[j + 1] !== undefined) {
                body += '<td>' + (row.c[j + 1].v * 100).toFixed(2) + ' %</td>';
              }
              else if (table.data.cols[j + 1].role !== undefined) {
                body += '<td>' + (row.c[j].v * 100).toFixed(2) + ' %</td>';
              }
              else {
                var value = row.c[j].v;
                if (String(value).indexOf("%") > -1) {
                  body += '<td> / </td>';
                }
                else {
                  body += '<td>' + row.c[j].v + '</td>';
                }

              }
            }
            else {
              body += '<td>' + row.c[j].v + '</td>';
            }

          }
          body += '</tr>';
        });
        body += '</tbody>';

        $element.find('.toggle_data_table .data_table').html('<table>' + head + body + '</table>');
        $element.find('.toggle_data_table').show();

      }

      function clearDataTable($element) {
        $element.find('.toggle_data_table').hide();
        $element.find('.toggle_data_table .data_table').hide();
        $element.find('.toggle_data_table .data_table').html('');
      }

      function drawChart(value, $element) {
        // Parse our data into a google visualization object.
        var data = new google.visualization.DataTable(value.data);
        var options = {
          'legend': {
            'position': 'none',
            'scrollArrows': {
              'activeColor': '#3f7ab0'
            },
            'pagingTextStyle': {
              'color': '#3f7ab0'
            }
          },
          'colors': ['#3f7ab0', '#d90040', '#feae22', '#00a651', '#92278f', '#c3c3c3']
        };

        // Extend our default options with the options form the json.
        _.merge(options, value.options.chartOptions);

        // Instantiate and draw our chart, passing in some options.
        var chart = new google.visualization[value.options.type]($element.find('.chart')[0]);

        // Add event listeren 'ready' to chart, so we can hide te loader.
        google.visualization.events.addListener(chart, 'ready', function () {
          $element.find(".loader").fadeOut();
        });
        chart.draw(data, options);
      }

      // Draw the filters for each chart.
      function drawFilters(options, $element, activeFilters) {
        var $selector = $element.find(".filters");
        var id = $element.attr('id');
        var html = '';

        if (options.toggleFilters != undefined && options.toggleFilters) {
          if (activeFilters === undefined || Object.keys(activeFilters).length === 0) {
            var filterOpen = 'right';
          }
          else {
            var filterOpen = 'down';
          }

          if (options.toggleFiltersOpen != undefined && options.toggleFiltersOpen) {
            var filterOpen = 'down';
          }

          html += '<h4 class="filter-title ' + filterOpen + '">' + Drupal.t('Filter') + '<span class="fa fa-caret-' + filterOpen + '"></span></h4><div class="filter-content">';
        }
        else {
          html += '<div>';
        }

        _.forEach(options.filters, function (filter, key) {

          // Check if there are filters active.
          if (activeFilters !== undefined && activeFilters.hasOwnProperty(filter.key)) {
            var activeFiltersLabels = [];
            // Loop over the active filters and push there names in an array.
            _.forEach(activeFilters[filter.key], function (activeFilter, key) {
              activeFiltersLabels.push($.grep(filter.values, function (e) {
                return e.key == activeFilter;
              })[0].name);
            });
            // Output the array as a string.
            if (activeFiltersLabels.length > 3) {
              var activeFiltersLabel = activeFiltersLabels.length + ' ' + Drupal.t('selected') + '&nbsp;';
            }
            else {
              var activeFiltersLabel = activeFiltersLabels.join(', ');
              activeFiltersLabel += ' ';
            }

          }
          else {
            var activeFiltersLabel = 'Filter ';
          }

          if (options.filterType != undefined && options.filterType == 'select') {
            var dropdown = '<div class="btn-group"><select class="form-control form-select" multiple>';
            _.forEach(filter.values, function (value, key) {
              // If filter is a active filter, set checked.
              var checked = '';
              if (activeFilters !== undefined && activeFilters.hasOwnProperty(filter.key)) {
                if (activeFilters[filter.key].indexOf(value.key.toString()) >= 0) {
                  checked = 'selected="selected"';
                }
              }
              else {
                if (value.default) {
                  checked = 'selected="selected"';
                  activeFiltersLabel = value.name;
                }
              }
              dropdown += '<option type="' + filter.type + '" id="' + id + '_' + value.key + '" name="' + id + '_' + filter.key + '" data-filter="' + filter.key + '" value="' + value.key + '" ' + checked + '>' + value.name + '</option>';
            });
            dropdown += '</select></div>';
          }
          else {
            var dropdown = '<div class="btn-group">' +
              '<button data-toggle="dropdown" data-placeholder="filter" class="btn btn-default dropdown-toggle">' + activeFiltersLabel + '<span class="caret"></span></button>' +
              '<ul class="dropdown-menu">';
            _.forEach(filter.values, function (value, key) {
              // If filter is a active filter, set checked.
              var checked = '';
              if (activeFilters !== undefined && activeFilters.hasOwnProperty(filter.key)) {
                if (activeFilters[filter.key].indexOf(value.key.toString()) >= 0) {
                  checked = 'checked="checked"';
                }
              }
              else {
                if (value.default) {
                  checked = 'checked="checked"';
                  activeFiltersLabel = value.name;
                }
              }
              dropdown += '<li>' +
                '<input type="' + filter.type + '" id="' + id + '_' + value.key + '" name="' + id + '_' + filter.key + '" data-filter="' + filter.key + '" value="' + value.key + '" ' + checked + ' />' +
                '<label for="' + id + '_' + value.key + '">' + value.name + '</label>' +
                '</li>';
            });
            dropdown += '</ul></div>';
          }

          html += '<div class="form-group ' + options.filterType + '">' +
            '<div class="input-group">' +
            '<label class="input-group-addon">' + filter.name + '</label>';
          html += dropdown;
          html += '</div></div>';

        });
        html += '<button class="btn btn-primary reset">' + Drupal.t('Reset');
        +'</button><div>';
        $selector.html(html);

        // Add event listener to filters.
        $selector.find('input, select').on('change', function () {
          var filter = $(this);

          var filters = {};
          _.forEach($selector.find('input:checked, option:checked'), function (value) {
            if (!filters.hasOwnProperty($(value).data('filter'))) {
              filters[$(value).data('filter')] = new Array();
            }
            filters[$(value).data('filter')].push($(value).val());
          });
          $element.data('filters', filters);
          $element.trigger("filters_updated");
        });

        $selector.find('button.reset').on('click', function () {
          $element.data('filters', '');
          $element.trigger("filters_updated");
        });

      }

      function drawTable(table, $element) {
        var head = '<thead>';
        var body = '<tbody>';


        head += '<tr>';
        _.forEach(table.data.cols, function (col) {
          if (col !== undefined) {
            if (col.children !== undefined) {
              var colspan = col.children.length;
              var rowspan = 1;
            }
            else {
              var colspan = 1;
              var rowspan = 2;
            }
            head += '<th colspan="' + colspan + '" rowspan="' + rowspan + '">' + col.name + '</th>';
          }
        });
        head += '</tr>';

        var cols = 0;
        head += '<tr class="children">';
        _.forEach(table.data.cols, function (col) {
          if (col !== undefined) {
            if (col.children !== undefined) {
              _.forEach(col.children, function (child) {
                head += '<th>' + child + '</th>';
                cols++;
              });
            }
            else {
              cols++;
            }
          }
        });
        head += '</tr>';

        head += '</thead>';

        _.forEach(table.data.rows, function (row) {
          if (row != undefined) {
            body += '<tr>';
            for (j = 0; j < cols; j++) {
              if (row[j] != undefined) {
                if (row[j].type == 'boolean') {
                  if (row[j].value == 1) {
                    body += '<td class="' + row[j].align + '"><div class="fa fa-check"></div></td>';
                  }
                  else {
                    body += '<td class="' + row[j].align + '"></td>';
                  }
                }
                else {
                  body += '<td class="' + row[j].align + '">' + row[j].value + '</td>';
                }
              }
            }
            body += '</tr>';
          }

        });
        body += '</tbody>';

        $element.find('.chart').html('<table>' + head + body + '</table>');
        $element.find('.chart').fadeIn();
        $element.find(".loader").fadeOut();

        new Drupal.stickyTableHeader($element.find('.chart table'));
      }

      function clearTable($element) {
        $element.find('.chart').hide();
        $element.find('.chart').html('');
      }

      // events

      $('.toggle_data_table .btn').on('click', function () {
        $(this).next().slideToggle();
      });


    }
  };
})(jQuery);;
(function ($) {
    Drupal.behaviors.eafoStatisticsHelper = {
        serializeFilters : function(filters) {
            var str = "";
            for (var filter in filters) {
                for (var value in filters[filter]) {
                    if (str != "") {
                        str += "&";
                    }
                    str += filter + "[]=" + filters[filter][value];
                }
            }
            return str;
        }
    }
})(jQuery);


;
