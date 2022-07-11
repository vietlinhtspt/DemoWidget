class TimeKeepingByMonthResponse {
  var code;
  String? message;
  Data? data;

  TimeKeepingByMonthResponse({this.code, this.message, this.data});

  TimeKeepingByMonthResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Statistics? statistics;
  List<DayDetail>? list;

  Data({this.statistics, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    statistics = json['statistics'] != null
        ? new Statistics.fromJson(json['statistics'])
        : null;
    if (json['list'] != null) {
      list = <DayDetail>[];
      json['list'].forEach((v) {
        list!.add(new DayDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.statistics != null) {
      data['statistics'] = this.statistics!.toJson();
    }
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Statistics {
  var userUnpaidLeaveDays;
  var userWorkFromHomeDays;
  var userOnLeaveDays;
  var totalWorkingDays;
  var totalTimeKeeping;
  var totalHours;
  var userWorkingDays;
  var userTotalTimekeeping;
  var userTotalHours;
  var userPunishDays;
  var userPunishAmount;

  Statistics(
      {this.userUnpaidLeaveDays,
      this.userWorkFromHomeDays,
      this.userOnLeaveDays,
      this.totalWorkingDays,
      this.totalTimeKeeping,
      this.totalHours,
      this.userWorkingDays,
      this.userTotalTimekeeping,
      this.userTotalHours,
      this.userPunishDays,
      this.userPunishAmount});

  Statistics.fromJson(Map<String, dynamic> json) {
    userUnpaidLeaveDays = json['user_unpaid_leave_days'];
    userWorkFromHomeDays = json['user_work_from_home_days'];
    userOnLeaveDays = json['user_on_leave_days'];
    totalWorkingDays = json['total_working_days'];
    totalTimeKeeping = json['total_time_keeping'];
    totalHours = json['total_hours'];
    userWorkingDays = json['user_working_days'];
    userTotalTimekeeping = json['user_total_timekeeping'];
    userTotalHours = json['user_total_hours'];
    userPunishDays = json['user_punish_days'];
    userPunishAmount = json['user_punish_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_unpaid_leave_days'] = this.userUnpaidLeaveDays;
    data['user_work_from_home_days'] = this.userWorkFromHomeDays;
    data['user_on_leave_days'] = this.userOnLeaveDays;
    data['total_working_days'] = this.totalWorkingDays;
    data['total_time_keeping'] = this.totalTimeKeeping;
    data['total_hours'] = this.totalHours;
    data['user_working_days'] = this.userWorkingDays;
    data['user_total_timekeeping'] = this.userTotalTimekeeping;
    data['user_total_hours'] = this.userTotalHours;
    data['user_punish_days'] = this.userPunishDays;
    data['user_punish_amount'] = this.userPunishAmount;
    return data;
  }
}

class DayDetail {
  var id;
  var userId;
  String? date;
  String? checkInAt;
  String? checkOutAt;
  var weekDay;
  var checkInLateIn;
  var checkOutEarlyIn;
  var agreeCheckInLate;
  var agreeCheckOutEarly;
  var agreeCheckInLateIn;
  var agreeCheckOutEarlyIn;
  var checkInLatePenalty;
  var checkOutEarlyPenalty;
  var totalTimekeeping;
  var totalHour;
  var month;
  var year;
  String? createdAt;
  String? updatedAt;
  var morningTimekeeping;
  var afternoonTimekeeping;
  String? note;
  var createdBy;

  DayDetail(
      {this.id,
      this.userId,
      this.date,
      this.checkInAt,
      this.checkOutAt,
      this.weekDay,
      this.checkInLateIn,
      this.checkOutEarlyIn,
      this.agreeCheckInLate,
      this.agreeCheckOutEarly,
      this.agreeCheckInLateIn,
      this.agreeCheckOutEarlyIn,
      this.checkInLatePenalty,
      this.checkOutEarlyPenalty,
      this.totalTimekeeping,
      this.totalHour,
      this.month,
      this.year,
      this.createdAt,
      this.updatedAt,
      this.morningTimekeeping,
      this.afternoonTimekeeping,
      this.note,
      this.createdBy});

  DayDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    date = json['date'];
    checkInAt = json['check_in_at'];
    checkOutAt = json['check_out_at'];
    weekDay = json['week_day'];
    checkInLateIn = json['check_in_late_in'];
    checkOutEarlyIn = json['check_out_early_in'];
    agreeCheckInLate = json['agree_check_in_late'];
    agreeCheckOutEarly = json['agree_check_out_early'];
    agreeCheckInLateIn = json['agree_check_in_late_in'];
    agreeCheckOutEarlyIn = json['agree_check_out_early_in'];
    checkInLatePenalty = json['check_in_late_penalty'];
    checkOutEarlyPenalty = json['check_out_early_penalty'];
    totalTimekeeping = json['total_timekeeping'];
    totalHour = json['total_hour'];
    month = json['month'];
    year = json['year'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    morningTimekeeping = json['morning_timekeeping'];
    afternoonTimekeeping = json['afternoon_timekeeping'];
    note = json['note'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['date'] = this.date;
    data['check_in_at'] = this.checkInAt;
    data['check_out_at'] = this.checkOutAt;
    data['week_day'] = this.weekDay;
    data['check_in_late_in'] = this.checkInLateIn;
    data['check_out_early_in'] = this.checkOutEarlyIn;
    data['agree_check_in_late'] = this.agreeCheckInLate;
    data['agree_check_out_early'] = this.agreeCheckOutEarly;
    data['agree_check_in_late_in'] = this.agreeCheckInLateIn;
    data['agree_check_out_early_in'] = this.agreeCheckOutEarlyIn;
    data['check_in_late_penalty'] = this.checkInLatePenalty;
    data['check_out_early_penalty'] = this.checkOutEarlyPenalty;
    data['total_timekeeping'] = this.totalTimekeeping;
    data['total_hour'] = this.totalHour;
    data['month'] = this.month;
    data['year'] = this.year;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['morning_timekeeping'] = this.morningTimekeeping;
    data['afternoon_timekeeping'] = this.afternoonTimekeeping;
    data['note'] = this.note;
    data['created_by'] = this.createdBy;
    return data;
  }
}
