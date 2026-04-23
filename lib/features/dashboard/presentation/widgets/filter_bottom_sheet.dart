import 'package:digihealth/features/dashboard/provider/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// A futuristic cascading filter bottom sheet
/// Region → Province (API) → UMMC (API) + Date Range + Tranche + Itinérance
class FilterBottomSheet extends ConsumerStatefulWidget {
  /// Callback when filters are applied
  /// Passes (region, province, ummc, fromDate, toDate, tranche, isItinerance)
  final Function(
      String? region,
      String? province,
      String? ummc,
      String? fromDate,
      String? toDate,
      int? tranche,
      bool isItinerance)? onFilterApplied;

  const FilterBottomSheet({
    super.key,
    this.onFilterApplied,
  });

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  // Local temporary selections (not applied until button is pressed)
  String? _selectedRegion;
  String? _selectedProvince;
  String? _selectedUmmc;
  DateTime? _fromDate;
  DateTime? _toDate;
  int? _selectedTranche;
  bool _isItinerance = false;
  bool _showDatePicker = false;

  @override
  void initState() {
    super.initState();

    // Initialize with current selections
    final filterState = ref.read(filterProvider);
    final currentSelection = filterState.currentSelection;
    _selectedRegion = currentSelection.region;
    _selectedProvince = currentSelection.province;
    _selectedUmmc = currentSelection.ummc;
    _fromDate = currentSelection.fromDate;
    _toDate = currentSelection.toDate;
    _selectedTranche = currentSelection.tranche;
    _isItinerance = currentSelection.isItinerance;

    // Automatically fetch filter data if not available
    if (filterState.availableFilters == null && !filterState.isLoading) {
      debugPrint('🔄 Filter data not available, triggering fetch...');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(filterProvider.notifier).fetchFilterData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(filterProvider);
    final availableFilters = filterState.availableFilters;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF051024), // Dark blue background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          _buildHandleBar(),

          // Title
          _buildTitle(),

          SizedBox(height: 24.h),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Filter dropdowns
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        // Show loading indicator if initial data is being fetched
                        if (filterState.isLoading)
                          _buildLoadingState('Chargement des régions...')
                        // Show error if there's an error
                        else if (filterState.errorMessage != null)
                          _buildErrorState(filterState.errorMessage!)
                        // Show message if no data available
                        else if (availableFilters == null ||
                            availableFilters.isEmpty)
                          _buildNoDataState()
                        // Show cascade dropdowns
                        else
                          ..._buildCascadingDropdowns(
                              filterState, availableFilters),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Date Range Section
                  _buildDateRangeSection(),

                  SizedBox(height: 24.h),

                  // Itinérance Checkbox
                  _buildItineranceCheckbox(),

                  SizedBox(height: 24.h),

                  // Action buttons
                  _buildActionButtons(context),

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build cascading dropdowns
  List<Widget> _buildCascadingDropdowns(
      FilterState filterState, availableFilters) {
    return [
      // 1. REGION DROPDOWN (always enabled)
      _buildDropdown(
        label: 'Région',
        value: _selectedRegion,
        items: availableFilters.regions,
        onChanged: (value) async {
          setState(() {
            _selectedRegion = value;
            _selectedProvince = null; // Clear dependent
            _selectedUmmc = null; // Clear dependent
          });

          if (value != null) {
            // Fetch provinces for selected region
            await ref
                .read(filterProvider.notifier)
                .fetchProvincesForRegion(value);
          } else {
            // Clear provinces and ummcs
            ref.read(filterProvider.notifier).selectRegion(null);
          }
        },
        hint: 'Sélectionner une région',
        enabled: true,
      ),

      SizedBox(height: 16.h),

      // 2. PROVINCE DROPDOWN (enabled only when region is selected)
      _buildDropdown(
        label: 'Province',
        value: _selectedProvince,
        items: filterState.availableProvinces,
        onChanged: (_selectedRegion != null)
            ? (value) async {
                setState(() {
                  _selectedProvince = value;
                  _selectedUmmc = null; // Clear dependent
                });

                if (value != null && _selectedRegion != null) {
                  // Fetch UMMCs for selected province
                  await ref
                      .read(filterProvider.notifier)
                      .fetchUmmcsForProvince(_selectedRegion!, value);
                } else {
                  // Clear UMMCs
                  ref.read(filterProvider.notifier).selectProvince(null);
                }
              }
            : null,
        hint: _selectedRegion == null
            ? 'Sélectionnez d\'abord une région'
            : 'Sélectionner une province',
        enabled: _selectedRegion != null,
        isLoading: filterState.isLoadingProvinces,
      ),

      SizedBox(height: 16.h),

      // 3. UMMC DROPDOWN (enabled only when province is selected)
      _buildDropdown(
        label: 'UMMC',
        value: _selectedUmmc,
        items: filterState.availableUmmcs,
        onChanged: (_selectedProvince != null)
            ? (value) {
                setState(() {
                  _selectedUmmc = value;
                });
                ref.read(filterProvider.notifier).selectUmmc(value);
              }
            : null,
        hint: _selectedProvince == null
            ? 'Sélectionnez d\'abord une province'
            : 'Sélectionner un UMMC',
        enabled: _selectedProvince != null,
        isLoading: filterState.isLoadingUmmcs,
      ),

      SizedBox(height: 16.h),

      // 4. TRANCHE DROPDOWN (always enabled)
      _buildDropdown(
        label: 'Tranche',
        value: _selectedTranche?.toString(),
        items: ['1', '2'],
        onChanged: (value) {
          setState(() {
            _selectedTranche = value != null ? int.tryParse(value) : null;
          });
          ref.read(filterProvider.notifier).selectTranche(
                value != null ? int.tryParse(value) : null,
              );
        },
        hint: 'Sélectionner une tranche',
        enabled: true,
        itemBuilder: (item) => 'Tranche $item',
      ),
    ];
  }

  /// Handle bar at the top
  Widget _buildHandleBar() {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  /// Title section
  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_list_rounded,
            color: Colors.cyanAccent,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            'Filtrer les données',
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Loading state widget
  Widget _buildLoadingState(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          const CircularProgressIndicator(
            color: Colors.cyanAccent,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Error state widget
  Widget _buildErrorState(String error) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.redAccent, size: 32.sp),
          SizedBox(height: 12.h),
          Text(
            'Erreur de chargement',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              ref.read(filterProvider.notifier).fetchFilterData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: const Color(0xFF051024),
            ),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  /// No data state widget
  Widget _buildNoDataState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          Icon(Icons.info_outline, color: Colors.orangeAccent, size: 32.sp),
          SizedBox(height: 12.h),
          Text(
            'Aucune donnée de filtre',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(filterProvider.notifier).fetchFilterData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: const Color(0xFF051024),
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Charger les filtres'),
          ),
        ],
      ),
    );
  }

  /// Build a single dropdown
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    required String hint,
    bool enabled = true,
    bool isLoading = false,
    String Function(String)? itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.cyanAccent,
                letterSpacing: 0.3,
              ),
            ),
            if (isLoading) ...[
              SizedBox(width: 8.w),
              SizedBox(
                width: 14.w,
                height: 14.h,
                child: const CircularProgressIndicator(
                  color: Colors.cyanAccent,
                  strokeWidth: 2,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 8.h),

        // Dropdown container
        Container(
          decoration: BoxDecoration(
            color: enabled
                ? const Color(0xFF0A1F38)
                : const Color(0xFF0A1F38).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: enabled
                  ? Colors.cyanAccent.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: enabled
                      ? Colors.white.withOpacity(0.5)
                      : Colors.grey.withOpacity(0.5),
                ),
              ),
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: enabled ? Colors.cyanAccent : Colors.grey,
                size: 24.sp,
              ),
              dropdownColor: const Color(0xFF0A1F38),
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              items: [
                // Add "Clear selection" option if value is not null
                if (value != null)
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(
                      '✕ Effacer la sélection',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.redAccent,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                // Regular items
                ...items.map((item) {
                  final displayText =
                      itemBuilder != null ? itemBuilder(item) : item;
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      displayText,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ],
              onChanged: enabled && !isLoading ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }

  /// Date Range Section
  Widget _buildDateRangeSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Range Header
          InkWell(
            onTap: () {
              setState(() {
                _showDatePicker = !_showDatePicker;
              });
            },
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF0A1F38),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.cyanAccent.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.cyanAccent,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Période',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.cyanAccent,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _getDateRangeText(),
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _showDatePicker
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.cyanAccent,
                    size: 24.sp,
                  ),
                ],
              ),
            ),
          ),

          // Dual Month Calendar
          if (_showDatePicker) ...[
            SizedBox(height: 16.h),
            _buildDualMonthCalendar(),
          ],
        ],
      ),
    );
  }

  String _getDateRangeText() {
    if (_fromDate == null && _toDate == null) {
      return 'Sélectionner une période';
    }
    final formatter = DateFormat('dd MMM yyyy', 'fr_FR');
    if (_fromDate != null && _toDate != null) {
      return '${formatter.format(_fromDate!)} - ${formatter.format(_toDate!)}';
    } else if (_fromDate != null) {
      return 'Du ${formatter.format(_fromDate!)}';
    } else {
      return 'Jusqu\'au ${formatter.format(_toDate!)}';
    }
  }

  /// Dual Month Calendar
  Widget _buildDualMonthCalendar() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    final nextMonth = DateTime(now.year, now.month + 1, 1);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1F38),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Two months side by side
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildMonthCalendar(currentMonth),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildMonthCalendar(nextMonth),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Date Picker Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // EFFACER
              TextButton(
                onPressed: () {
                  setState(() {
                    _fromDate = null;
                    _toDate = null;
                  });
                  // Save cleared dates to provider
                  ref.read(filterProvider.notifier).selectDateRange(null, null);
                },
                child: Text(
                  'EFFACER',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
              ),

              // ANNULER
              TextButton(
                onPressed: () {
                  setState(() {
                    _showDatePicker = false;
                  });
                },
                child: Text(
                  'ANNULER',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),

              // VALIDER
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showDatePicker = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: const Color(0xFF051024),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'VALIDER',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build a single month calendar
  Widget _buildMonthCalendar(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstDayOfWeek = DateTime(month.year, month.month, 1).weekday;

    return Column(
      children: [
        // Month name
        Text(
          DateFormat('MMMM yyyy', 'fr_FR').format(month),
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.cyanAccent,
          ),
        ),
        SizedBox(height: 8.h),

        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['L', 'M', 'M', 'J', 'V', 'S', 'D'].map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 8.h),

        // Calendar grid
        ...List.generate(6, (weekIndex) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (dayIndex) {
                final dayNumber =
                    weekIndex * 7 + dayIndex + 1 - (firstDayOfWeek - 1);

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return Expanded(child: SizedBox(height: 26.h));
                }

                final date = DateTime(month.year, month.month, dayNumber);
                final isSelected =
                    (_fromDate != null && _isSameDay(_fromDate!, date)) ||
                        (_toDate != null && _isSameDay(_toDate!, date));
                final isInRange = _isInDateRange(date);
                final isToday = _isSameDay(date, DateTime.now());

                return Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(date),
                    child: Container(
                      height: 26.h,
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.cyanAccent
                            : isInRange
                                ? Colors.cyanAccent.withOpacity(0.2)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isToday
                            ? Border.all(color: Colors.orangeAccent, width: 1.5)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '$dayNumber',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w400,
                            color: isSelected
                                ? const Color(0xFF051024)
                                : Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isInDateRange(DateTime date) {
    if (_fromDate == null || _toDate == null) return false;
    return date.isAfter(_fromDate!) && date.isBefore(_toDate!);
  }

  void _selectDate(DateTime date) {
    setState(() {
      if (_fromDate == null || (_fromDate != null && _toDate != null)) {
        // Start new selection
        _fromDate = date;
        _toDate = null;
      } else if (_fromDate != null && _toDate == null) {
        // Complete the range
        if (date.isBefore(_fromDate!)) {
          _toDate = _fromDate;
          _fromDate = date;
        } else {
          _toDate = date;
        }
      }

      // Save to provider
      ref.read(filterProvider.notifier).selectDateRange(_fromDate, _toDate);
    });
  }

  /// Itinérance Checkbox Section
  Widget _buildItineranceCheckbox() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF0A1F38),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.cyanAccent.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: Checkbox(
                value: _isItinerance,
                onChanged: (value) {
                  setState(() {
                    _isItinerance = value ?? false;
                  });
                  ref
                      .read(filterProvider.notifier)
                      .selectItinerance(value ?? false);
                },
                activeColor: Colors.cyanAccent,
                checkColor: const Color(0xFF051024),
                side: BorderSide(
                  color: Colors.cyanAccent.withOpacity(0.5),
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Label
            Expanded(
              child: Text(
                'Itinérance',
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Action buttons at the bottom
  Widget _buildActionButtons(BuildContext context) {
    final hasSelection = _selectedRegion != null ||
        _selectedProvince != null ||
        _selectedUmmc != null ||
        _fromDate != null ||
        _toDate != null ||
        _selectedTranche != null ||
        _isItinerance;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          // Clear all button
          if (hasSelection)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedRegion = null;
                    _selectedProvince = null;
                    _selectedUmmc = null;
                    _fromDate = null;
                    _toDate = null;
                    _selectedTranche = null;
                    _isItinerance = false;
                  });
                  ref.read(filterProvider.notifier).clearFilters();
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  side: BorderSide(
                    color: Colors.redAccent.withOpacity(0.5),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Réinitialiser',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),

          if (hasSelection) SizedBox(width: 12.w),

          // Apply button
          Expanded(
            flex: hasSelection ? 1 : 2,
            child: ElevatedButton(
              onPressed: hasSelection
                  ? () {
                      // Format dates to API format
                      final fromDateStr = _fromDate != null
                          ? DateFormat('yyyy-MM-dd').format(_fromDate!)
                          : null;
                      final toDateStr = _toDate != null
                          ? DateFormat('yyyy-MM-dd').format(_toDate!)
                          : null;

                      // Call callback with all seven values
                      widget.onFilterApplied?.call(
                        _selectedRegion,
                        _selectedProvince,
                        _selectedUmmc,
                        fromDateStr,
                        toDateStr,
                        _selectedTranche,
                        _isItinerance,
                      );

                      // Close bottom sheet
                      Navigator.pop(context);
                    }
                  : null, // Disabled when no filters selected
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                backgroundColor: hasSelection
                    ? Colors.cyanAccent
                    : Colors.grey.withOpacity(0.3),
                foregroundColor: hasSelection
                    ? const Color(0xFF051024)
                    : Colors.grey.withOpacity(0.5),
                elevation: hasSelection ? 8 : 0,
                shadowColor: hasSelection
                    ? Colors.cyanAccent.withOpacity(0.5)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Appliquer les filtres',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper function to show the filter bottom sheet
void showFilterBottomSheet(
  BuildContext context, {
  Function(String? region, String? province, String? ummc, String? fromDate,
          String? toDate, int? tranche, bool isItinerance)?
      onFilterApplied,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FilterBottomSheet(
      onFilterApplied: onFilterApplied,
    ),
  );
}
