// ignore_for_file: non_constant_identifier_names
part of amap_view_muka;

class PathPlanningStrategy {
  static final int NO_STRATEGY = -1;

  /// 速度优先，不考虑当时路况，返回耗时最短的路线，但是此路线不一定距离最短
  static final int DRIVING_DEFAULT = 0;

  /// 费用优先，不走收费路段，且耗时最少的路线
  static final int DRIVING_SAVE_MONEY = 1;

  /// 距离优先，不考虑路况，仅走距离最短的路线，但是可能存在穿越小路/小区的情况
  static final int DRIVING_SHORTEST_DISTANCE = 2;

  /// 速度优先，不走快速路，例如京通快速路（因为策略迭代，建议使用13）
  static final int DRIVING_NO_EXPRESS_WAYS = 3;

  /// 躲避拥堵，但是可能会存在绕路的情况，耗时可能较长
  static final int DRIVING_AVOID_CONGESTION = 4;

  /// 多策略（同时使用速度优先、费用优先、距离优先三个策略计算路径）。其中必须说明，就算使用三个策略算路，会根据路况不固定的返回一到三条路径规划信息
  static final int DRIVING_MULTIPLE_PRIORITY_SPEED_COST_DISTANCE = 5;

  /// 速度优先，不走高速，但是不排除走其余收费路段
  static final int DRIVING_SINGLE_ROUTE_AVOID_HIGHSPEED = 6;

  /// 费用优先，不走高速且避免所有收费路段
  static final int DRIVING_SINGLE_ROUTE_AVOID_HIGHSPEED_COST = 7;

  /// 躲避拥堵和收费，可能存在走高速的情况，并且考虑路况不走拥堵路线，但有可能存在绕路和时间较长
  static final int DRIVING_SINGLE_ROUTE_AVOID_CONGESTION_COST = 8;

  /// 躲避拥堵和收费，不走高速
  static final int DRIVING_SINGLE_ROUTE_AVOID_HIGHSPEED_COST_CONGESTION = 9;

  /// 返回结果会躲避拥堵，路程较短，尽量缩短时间，与高德地图的默认策略（也就是不进行任何勾选）一致
  static final int DRIVING_MULTIPLE_ROUTES_DEFAULT = 10;

  /// 返回三个结果包含：时间最短；距离最短；躲避拥堵（由于有更优秀的算法，建议用10代替）
  static final int DRIVING_MULTIPLE_SHORTEST_TIME_DISTANCE = 11;

  /// 返回的结果考虑路况，尽量躲避拥堵而规划路径，与高德地图的“躲避拥堵”策略一致
  static final int DRIVING_MULTIPLE_ROUTES_AVOID_CONGESTION = 12;

  /// 返回的结果不走高速，与高德地图“不走高速”策略一致
  static final int DRIVING_MULTIPLE_ROUTES_AVOID_HIGHSPEED = 13;

  /// 返回的结果尽可能规划收费较低甚至免费的路径，与高德地图“避免收费”策略一致
  static final int DRIVING_MULTIPLE_ROUTES_AVOID_COST = 14;

  /// 返回的结果考虑路况，尽量躲避拥堵而规划路径，并且不走高速，与高德地图的“躲避拥堵&不走高速”策略一致
  static final int DRIVING_MULTIPLE_ROUTES_AVOID_HIGHSPEED_CONGESTION = 15;

  /// 返回的结果尽量不走高速，并且尽量规划收费较低甚至免费的路径结果，与高德地图的“避免收费&不走高速”策略一致
  static final int DRIVING_MULTIPLE_ROUTES_AVOID_HIGHTSPEED_COST = 16;

  /// 返回路径规划结果会尽量的躲避拥堵，并且规划收费较低甚至免费的路径结果，与高德地图的“躲避拥堵&避免收费”策略一致
  static final int DRIVING_MULTIPLE_ROUTES_AVOID_COST_CONGESTION = 17;

  /// 返回的结果尽量躲避拥堵，规划收费较低甚至免费的路径结果，并且尽量不走高速路，与高德地图的“避免拥堵&避免收费&不走高速”策略一致
  static final int DRIVING_MULTIPLE_ROUTES_AVOID_HIGHSPEED_COST_CONGESTION = 18;

  /// 返回的结果会优先选择高速路，与高德地图的“高速优先”策略一致
  static final int DRIVING_MULTIPLE_ROUTES_PRIORITY_HIGHSPEED = 19;

  /// 返回的结果会优先考虑高速路，并且会考虑路况躲避拥堵，与高德地图的“躲避拥堵&高速优先”策略一致
  static final int DRIVING_MULTIPLE_ROUTES_PRIORITY_HIGHSPEED_AVOID_CONGESTION = 20;

  static final int MOTOR_MULTIPLE_DEFAULT = 2001;
  static final int MOTOR_MULTIPLE_AVOID_HIGHWAY = 2002;
  static final int MOTOR_MULTIPLE_PRIORITISE_HIGHWAY = 2003;
  static final int MOTOR_MULTIPLE_AVOID_COST = 2004;
}
