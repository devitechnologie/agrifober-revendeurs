import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fui_kit/fui_kit.dart';
// local imports
import 'package:agrifober_resellers/config/theme/app_font_sizes.dart';
import 'package:agrifober_resellers/config/theme/app_colors.dart';
import 'package:agrifober_resellers/gen/assets.gen.dart';

// type alias for icon function
typedef AppIcon = Widget Function({Color? color, double? size});

class AppIcons {
  static AppIcon closeRR = ({Color? color, double? size}) => FUI(
    RegularRounded.CROSS_SMALL,
    color: color,
    height: size ?? AppFontSize.lg,
    width: size ?? AppFontSize.lg,
  );

  static AppIcon squaredExamIconRR = ({Color? color, double? size}) => FUI(
    RegularRounded.EXCLAMATION,
    color: color,
    height: size ?? AppFontSize.xl,
    width: size ?? AppFontSize.xl,
  );

  static AppIcon checkRR = ({Color? color, double? size}) => FUI(
    RegularRounded.CHECK,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon questionIconRR = ({Color? color, double? size}) => FUI(
    RegularRounded.COMMENT_INFO,
    color: color,
    height: size ?? AppFontSize.xl,
    width: size ?? AppFontSize.xl,
  );

  static AppIcon arrowSmallRightIconRR = ({Color? color, double? size}) => FUI(
    RegularRounded.ARROW_SMALL_RIGHT,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon angleSmallRightIconRR = ({Color? color, double? size}) => FUI(
    RegularRounded.ANGLE_SMALL_RIGHT,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon arrowBack = ({Color? color, double? size}) => SvgPicture.asset(
    Assets.images.svg.arrowBack,
    width: size ?? AppFontSize.base,
    height: size ?? AppFontSize.base,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    fit: BoxFit.contain,
    clipBehavior: Clip.hardEdge,
    allowDrawingOutsideViewBox: false,
    semanticsLabel: 'Arrow back',
  );

  static AppIcon eyeRR = ({Color? color, double? size}) => FUI(
    RegularRounded.EYE,
    color: color,
    height: size ?? AppFontSize.xl,
    width: size ?? AppFontSize.xl,
  );

  static AppIcon eyeCrossedRR = ({Color? color, double? size}) => FUI(
    RegularRounded.EYE_CROSSED,
    color: color,
    height: size ?? AppFontSize.xl,
    width: size ?? AppFontSize.xl,
  );

  static AppIcon arrowDownIconRR = ({Color? color, double? size}) => FUI(
    RegularRounded.ANGLE_SMALL_DOWN,
    color: color,
    height: size ?? AppFontSize.xl,
    width: size ?? AppFontSize.xl,
  );

  static AppIcon calendarDay = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.calendarDay,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Calendar day',
      );

  static AppIcon calendarWeek = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.calendarWeek,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Calendar week',
      );

  static AppIcon calendar3Days = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.calendar3days,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Calendar 3 days',
      );

  static AppIcon calendarMonth = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.calendarMonth,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Calendar month',
      );

  static AppIcon plusRR = ({Color? color, double? size}) => FUI(
    RegularRounded.PLUS,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon plusSmallRR = ({Color? color, double? size}) => FUI(
    RegularRounded.PLUS_SMALL,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon filterRR = ({Color? color, double? size}) => FUI(
    RegularRounded.SETTINGS_SLIDERS,
    color: color,
    height: size ?? AppFontSize.xl,
    width: size ?? AppFontSize.xl,
  );

  static AppIcon arrowSmallDownRR = ({Color? color, double? size}) => FUI(
    RegularRounded.ANGLE_SMALL_DOWN,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon calendarPlus = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.calendarPlus,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Calendar plus',
      );

  static AppIcon timeWatchCalendar = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.timeWatchCalendar,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Time watch calendar',
      );

  static AppIcon buildingCircleArrow = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.buildingCircleArrowRight,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Building circle arrow',
      );

  static AppIcon calendarClock = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.calendarClock,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Calendar clock',
      );

  static AppIcon team = ({Color? color, double? size}) => SvgPicture.asset(
    Assets.images.svg.peopleGroup,
    width: size ?? AppFontSize.base,
    height: size ?? AppFontSize.base,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    fit: BoxFit.contain,
    clipBehavior: Clip.hardEdge,
    allowDrawingOutsideViewBox: false,
    semanticsLabel: 'Team',
  );

  static AppIcon thumbtackRR = ({Color? color, double? size}) => FUI(
    RegularRounded.THUMBTACK,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon listRR = ({Color? color, double? size}) => FUI(
    RegularRounded.LIST,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon lockRR = ({Color? color, double? size}) => FUI(
    RegularRounded.lock,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon userAddRR = ({Color? color, double? size}) => FUI(
    RegularRounded.USER_ADD,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon plusIconRR = ({Color? color, double? size}) => FUI(
    RegularRounded.ADD,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon searchRR = ({Color? color, double? size}) => FUI(
    RegularRounded.SEARCH,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon arrowRightIconRR = ({Color? color, double? size}) => FUI(
    RegularRounded.ANGLE_SMALL_RIGHT,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon replaceIconRR = ({Color? color, double? size}) => FUI(
    RegularRounded.SHUFFLE,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon editUserIconRR = ({Color? color, double? size}) => FUI(
    RegularRounded.EDIT,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon trashIconRR = ({Color? color, double? size}) => FUI(
    RegularRounded.TRASH,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon uploadRR = ({Color? color, double? size}) => FUI(
    RegularRounded.UPLOAD,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon cameraRR = ({Color? color, double? size}) => FUI(
    RegularRounded.CAMERA,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon cameraSR = ({Color? color, double? size}) => FUI(
    SolidRounded.CAMERA,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon shareSquareRR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.shareSquare,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Share',
      );

  static AppIcon creditCardEyeRR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.creditCardEye,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Credit card eye',
      );

  static AppIcon bankRR = ({Color? color, double? size}) => FUI(
    RegularRounded.BANK,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon clock = ({Color? color, double? size}) => FUI(
    RegularRounded.CLOCK,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon locationRR = ({Color? color, double? size}) => FUI(
    RegularRounded.MARKER,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon usersAltRR = ({Color? color, double? size}) => FUI(
    RegularRounded.USER,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon receiptRR = ({Color? color, double? size}) => FUI(
    RegularRounded.RECEIPT,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon sortAltRR = ({Color? color, double? size}) => FUI(
    RegularRounded.APPS_SORT,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon walletRR = ({Color? color, double? size}) => FUI(
    RegularRounded.MONEY,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon megaphoneRR = ({Color? color, double? size}) => FUI(
    RegularRounded.MEGAPHONE,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon headphonesRR = ({Color? color, double? size}) => FUI(
    RegularRounded.HEADPHONES,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon signOutRR = ({Color? color, double? size}) => FUI(
    RegularRounded.SIGN_OUT,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon imagesRR = ({Color? color, double? size}) => SvgPicture.asset(
    Assets.images.svg.images,
    width: size ?? AppFontSize.xl,
    height: size ?? AppFontSize.xl,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    fit: BoxFit.contain,
    clipBehavior: Clip.hardEdge,
    allowDrawingOutsideViewBox: false,
    semanticsLabel: 'Images',
  );

  static AppIcon usersAltsRR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.usersAlt,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
      );

  static AppIcon validatingReceiptRR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.validatingReceipt,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
      );

  static AppIcon priorityImportanceRR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.priorityImportance,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
      );

  static AppIcon walletArrowRR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.walletArrow,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
      );

  static AppIcon launchRR = ({Color? color, double? size}) => SvgPicture.asset(
    Assets.images.svg.launch,
    width: size ?? AppFontSize.base,
    height: size ?? AppFontSize.base,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    fit: BoxFit.contain,
  );

  static AppIcon userHeadsetRR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.userHeadset,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
      );

  static AppIcon signOutAltRR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.signOutAlt,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
      );

  static AppIcon menuDotsVerticalRR = ({Color? color, double? size}) => FUI(
    RegularRounded.MENU_DOTS_VERTICAL,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon cloudUploadRR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.cloudUpload,
        width: size ?? AppFontSize.xl,
        height: size ?? AppFontSize.xl,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Cloud upload',
      );

  static AppIcon commentSR = ({Color? color, double? size}) => SvgPicture.asset(
    Assets.images.svg.commentSolid,
    width: size ?? AppFontSize.base,
    height: size ?? AppFontSize.base,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    fit: BoxFit.contain,
    clipBehavior: Clip.hardEdge,
    allowDrawingOutsideViewBox: false,
    semanticsLabel: 'Comment',
  );

  static AppIcon envelopeSR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.envelopeSolid,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Envelope',
      );

  static AppIcon phoneSR = ({Color? color, double? size}) => SvgPicture.asset(
    Assets.images.svg.phoneSolid,
    width: size ?? AppFontSize.base,
    height: size ?? AppFontSize.base,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    fit: BoxFit.contain,
    clipBehavior: Clip.hardEdge,
    allowDrawingOutsideViewBox: false,
    semanticsLabel: 'Phone',
  );

  static AppIcon whatsappSR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.whatsappSolid,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'WhatsApp',
      );

  // usePen
  static AppIcon userPenRR = ({Color? color, double? size}) => SvgPicture.asset(
    Assets.images.svg.userPen,
    width: size ?? AppFontSize.base,
    height: size ?? AppFontSize.base,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    fit: BoxFit.contain,
    clipBehavior: Clip.hardEdge,
    allowDrawingOutsideViewBox: false,
    semanticsLabel: 'User pen',
  );

  static AppIcon alarmClock = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.alarmClock,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Alarm clock',
      );

  static AppIcon calendarMinus = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.calendarMinus,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Calendar minus',
      );

  static AppIcon paperPlane = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.paperPlane,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Paper plane',
      );

  static AppIcon homeActive = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.homeActive,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Home active',
      );

  static AppIcon homeInactive = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.homeInactive,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Home inactive',
      );

  static AppIcon searchActive = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.searchActive,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Search active',
      );

  static AppIcon searchInactive = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.searchInactive,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Search inactive',
      );

  static AppIcon calendarActive = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.calendarActive,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Calendar active',
      );

  static AppIcon calendarInactive = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.calendarInactive,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Calendar inactive',
      );

  static AppIcon userActive = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.userActive,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'User active',
      );

  static AppIcon userInactive = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.userInactive,
        width: size ?? AppFontSize.base,
        height: size ?? AppFontSize.base,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'User inactive',
      );

  static AppIcon markerRR = ({Color? color, double? size}) => SvgPicture.asset(
    Assets.images.svg.marker,
    width: size ?? AppFontSize.base,
    height: size ?? AppFontSize.base,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    fit: BoxFit.contain,
    clipBehavior: Clip.hardEdge,
    allowDrawingOutsideViewBox: false,
    semanticsLabel: 'Marker',
  );

  static AppIcon markerSR = ({Color? color, double? size}) => SvgPicture.asset(
    Assets.images.svg.markerLight,
    width: size ?? AppFontSize.base,
    height: size ?? AppFontSize.base,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    fit: BoxFit.contain,
    clipBehavior: Clip.hardEdge,
    allowDrawingOutsideViewBox: false,
    semanticsLabel: 'MarkerSR',
  );

  static AppIcon locationCrosshairsRR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.locationCrosshairs,
        width: size ?? AppFontSize.lg,
        height: size ?? AppFontSize.lg,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Location crosshairs',
      );

  static AppIcon bellRR = ({Color? color, double? size}) => SvgPicture.asset(
    Assets.images.svg.bell,
    width: size ?? AppFontSize.base,
    height: size ?? AppFontSize.base,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    fit: BoxFit.contain,
    clipBehavior: Clip.hardEdge,
    allowDrawingOutsideViewBox: false,
    semanticsLabel: 'Bell',
  );

  static AppIcon appsRR = ({Color? color, double? size}) => SvgPicture.asset(
    Assets.images.svg.apps,
    width: size ?? AppFontSize.xl,
    height: size ?? AppFontSize.xl,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    fit: BoxFit.contain,
    clipBehavior: Clip.hardEdge,
    allowDrawingOutsideViewBox: false,
    semanticsLabel: 'Apps',
  );

  static AppIcon showerRR = ({Color? color, double? size}) => SvgPicture.asset(
    Assets.images.svg.shower,
    width: size ?? AppFontSize.xl,
    height: size ?? AppFontSize.xl,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    fit: BoxFit.contain,
    clipBehavior: Clip.hardEdge,
    allowDrawingOutsideViewBox: false,
    semanticsLabel: 'Shower',
  );

  static AppIcon hairdryerRR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.hairdryer,
        width: size ?? AppFontSize.xl,
        height: size ?? AppFontSize.xl,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Hairdryer',
      );

  static AppIcon barberShopRR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.barberShop,
        width: size ?? AppFontSize.xl,
        height: size ?? AppFontSize.xl,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Barber shop',
      );

  static AppIcon starSR = ({Color? color, double? size}) => SvgPicture.asset(
    Assets.images.svg.star,
    width: size ?? AppFontSize.base,
    height: size ?? AppFontSize.base,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    fit: BoxFit.contain,
    clipBehavior: Clip.hardEdge,
    allowDrawingOutsideViewBox: false,
    semanticsLabel: 'Star',
  );

  static AppIcon starRR = ({Color? color, double? size}) => SvgPicture.asset(
    Assets.images.svg.starRegular,
    width: size ?? AppFontSize.base,
    height: size ?? AppFontSize.base,
    colorFilter: ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
    fit: BoxFit.contain,
    clipBehavior: Clip.hardEdge,
    allowDrawingOutsideViewBox: false,
    semanticsLabel: 'Star Regular',
  );

  static AppIcon heartRR = ({Color? color, double? size}) => FUI(
    RegularRounded.HEART,
    color: color,
    height: size ?? AppFontSize.xs + 2,
    width: size ?? AppFontSize.xs + 2,
  );

  static AppIcon heartSR = ({Color? color, double? size}) => FUI(
    SolidRounded.heart,
    color: color,
    height: size ?? AppFontSize.xs + 2,
    width: size ?? AppFontSize.xs + 2,
  );

  static AppIcon hospitalRR = ({Color? color, double? size}) =>
      SvgPicture.asset(
        Assets.images.svg.hospital,
        width: size ?? AppFontSize.xl,
        height: size ?? AppFontSize.xl,
        colorFilter: ColorFilter.mode(
          color ?? AppColors.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.contain,
        clipBehavior: Clip.hardEdge,
        allowDrawingOutsideViewBox: false,
        semanticsLabel: 'Hospital',
      );

  // Agrifober revendeurs

  static AppIcon cartActive = ({Color? color, double? size}) => FUI(
    SolidRounded.SHOPPING_CART,
    color: color,
    height: size ?? AppFontSize.xl,
    width: size ?? AppFontSize.xl,
  );

  static AppIcon cartInactive = ({Color? color, double? size}) => FUI(
    RegularRounded.SHOPPING_CART,
    color: color,
    height: size ?? AppFontSize.xl,
    width: size ?? AppFontSize.xl,
  );

  static AppIcon historyActive = ({Color? color, double? size}) => FUI(
    SolidRounded.RECEIPT,
    color: color,
    height: size ?? AppFontSize.xl,
    width: size ?? AppFontSize.xl,
  );

  static AppIcon historyInactive = ({Color? color, double? size}) => FUI(
    RegularRounded.RECEIPT,
    color: color,
    height: size ?? AppFontSize.xl,
    width: size ?? AppFontSize.xl,
  );

  static AppIcon creditActive = ({Color? color, double? size}) => FUI(
    SolidRounded.CREDIT_CARD,
    color: color,
    height: size ?? AppFontSize.xl,
    width: size ?? AppFontSize.xl,
  );

  static AppIcon creditInactive = ({Color? color, double? size}) => FUI(
    RegularRounded.CREDIT_CARD,
    color: color,
    height: size ?? AppFontSize.xl,
    width: size ?? AppFontSize.xl,
  );

  static AppIcon minusSmallRR = ({Color? color, double? size}) => FUI(
    RegularRounded.MINUS_SMALL,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon downloadRR = ({Color? color, double? size}) => FUI(
    RegularRounded.DOWNLOAD,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon leafRR = ({Color? color, double? size}) => FUI(
    RegularRounded.LEAF,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon truckRR = ({Color? color, double? size}) => FUI(
    RegularRounded.TRUCK_SIDE,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon boxRR = ({Color? color, double? size}) => FUI(
    RegularRounded.BOX_ALT,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon documentRR = ({Color? color, double? size}) => FUI(
    RegularRounded.DOCUMENT,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon crossCircleRR = ({Color? color, double? size}) => FUI(
    RegularRounded.CROSS_CIRCLE,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon phoneCallRR = ({Color? color, double? size}) => FUI(
    RegularRounded.PHONE_CALL,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon infoRR = ({Color? color, double? size}) => FUI(
    RegularRounded.INFO,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon creditCardRR = ({Color? color, double? size}) => FUI(
    RegularRounded.CREDIT_CARD,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon chartRR = ({Color? color, double? size}) => FUI(
    RegularRounded.CHART_HISTOGRAM,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );

  static AppIcon cartRR = ({Color? color, double? size}) => FUI(
    RegularRounded.SHOPPING_CART,
    color: color,
    height: size ?? AppFontSize.base,
    width: size ?? AppFontSize.base,
  );
}
