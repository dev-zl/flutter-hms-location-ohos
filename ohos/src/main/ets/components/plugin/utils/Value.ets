/*
 * Copyright 2020-2024. Huawei Technologies Co., Ltd. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 */

export type AnyMap = Record<string, Object | null | undefined>;

export class Value {
  static createMap(): AnyMap {
    return new Object() as AnyMap;
  }

  static asMap(value: Object | null | undefined): AnyMap {
    if (value && typeof value === 'object' && !Array.isArray(value)) {
      return value as AnyMap;
    }
    return Value.createMap();
  }

  static mapValue(map: AnyMap, key: string): Object | null | undefined {
    return map[key];
  }

  static number(map: AnyMap, key: string, fallback: number = 0): number {
    const value = map[key];
    if (typeof value === 'number') {
      return value;
    }
    if (typeof value === 'string') {
      const parsed = Number(value);
      return isNaN(parsed) ? fallback : parsed;
    }
    return fallback;
  }

  static boolean(map: AnyMap, key: string, fallback: boolean = false): boolean {
    const value = map[key];
    return typeof value === 'boolean' ? value : fallback;
  }

  static string(map: AnyMap, key: string, fallback: string = ''): string {
    const value = map[key];
    return typeof value === 'string' ? value : fallback;
  }

  static errorCode(error: Object): string {
    const record = Value.asMap(error);
    const code = record['code'];
    return code === undefined || code === null ? 'LOCATION_ERROR' : String(code);
  }

  static errorMessage(error: Object): string {
    const record = Value.asMap(error);
    const message = record['message'];
    return message === undefined || message === null ? String(error) : String(message);
  }
}
