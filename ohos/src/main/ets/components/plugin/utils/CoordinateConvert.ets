/*
 * Copyright 2020-2024. Huawei Technologies Co., Ltd. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 */

export interface CoordinateResult {
  latitude: number;
  longitude: number;
}

export class CoordinateConvert {
  private static readonly PI: number = 3.1415926535897932384626;
  private static readonly A: number = 6378245.0;
  private static readonly EE: number = 0.00669342162296594323;

  static convert(latitude: number, longitude: number, coordType: number): CoordinateResult {
    if (coordType === 1 || CoordinateConvert.outOfChina(latitude, longitude)) {
      return { 'latitude': latitude, 'longitude': longitude };
    }
    const dLat = CoordinateConvert.transformLat(longitude - 105.0, latitude - 35.0);
    const dLon = CoordinateConvert.transformLon(longitude - 105.0, latitude - 35.0);
    const radLat = latitude / 180.0 * CoordinateConvert.PI;
    let magic = Math.sin(radLat);
    magic = 1 - CoordinateConvert.EE * magic * magic;
    const sqrtMagic = Math.sqrt(magic);
    const mgLat = latitude + (dLat * 180.0) / ((CoordinateConvert.A * (1 - CoordinateConvert.EE)) / (magic * sqrtMagic) * CoordinateConvert.PI);
    const mgLon = longitude + (dLon * 180.0) / (CoordinateConvert.A / sqrtMagic * Math.cos(radLat) * CoordinateConvert.PI);
    return { 'latitude': mgLat, 'longitude': mgLon };
  }

  private static outOfChina(lat: number, lon: number): boolean {
    return lon < 72.004 || lon > 137.8347 || lat < 0.8293 || lat > 55.8271;
  }

  private static transformLat(x: number, y: number): number {
    let ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * Math.sqrt(Math.abs(x));
    ret += (20.0 * Math.sin(6.0 * x * CoordinateConvert.PI) + 20.0 * Math.sin(2.0 * x * CoordinateConvert.PI)) * 2.0 / 3.0;
    ret += (20.0 * Math.sin(y * CoordinateConvert.PI) + 40.0 * Math.sin(y / 3.0 * CoordinateConvert.PI)) * 2.0 / 3.0;
    ret += (160.0 * Math.sin(y / 12.0 * CoordinateConvert.PI) + 320 * Math.sin(y * CoordinateConvert.PI / 30.0)) * 2.0 / 3.0;
    return ret;
  }

  private static transformLon(x: number, y: number): number {
    let ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * Math.sqrt(Math.abs(x));
    ret += (20.0 * Math.sin(6.0 * x * CoordinateConvert.PI) + 20.0 * Math.sin(2.0 * x * CoordinateConvert.PI)) * 2.0 / 3.0;
    ret += (20.0 * Math.sin(x * CoordinateConvert.PI) + 40.0 * Math.sin(x / 3.0 * CoordinateConvert.PI)) * 2.0 / 3.0;
    ret += (150.0 * Math.sin(x / 12.0 * CoordinateConvert.PI) + 300.0 * Math.sin(x / 30.0 * CoordinateConvert.PI)) * 2.0 / 3.0;
    return ret;
  }
}
