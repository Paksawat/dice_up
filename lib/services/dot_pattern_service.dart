import 'package:flutter/material.dart';

class DotPatternService {
  static Widget buildDots(int value, Color dotColor) {
    switch (value) {
      case 1:
        return _buildCenterDot(dotColor);
      case 2:
        return _buildTwoDots(dotColor);
      case 3:
        return _buildThreeDots(dotColor);
      case 4:
        return _buildFourDots(dotColor);
      case 5:
        return _buildFiveDots(dotColor);
      case 6:
        return _buildSixDots(dotColor);
      default:
        return _buildCenterDot(dotColor);
    }
  }

  static Widget _buildCenterDot(Color dotColor) {
    return Center(
      child: _dot(dotColor),
    );
  }

  static Widget _buildTwoDots(Color dotColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_dot(dotColor)],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_dot(dotColor)],
        ),
      ],
    );
  }

  static Widget _buildThreeDots(Color dotColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_dot(dotColor)],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_dot(dotColor)],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_dot(dotColor)],
        ),
      ],
    );
  }

  static Widget _buildFourDots(Color dotColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(dotColor), _dot(dotColor)],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(dotColor), _dot(dotColor)],
        ),
      ],
    );
  }

  static Widget _buildFiveDots(Color dotColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(dotColor), _dot(dotColor)],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_dot(dotColor)],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(dotColor), _dot(dotColor)],
        ),
      ],
    );
  }

  static Widget _buildSixDots(Color dotColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(dotColor), _dot(dotColor)],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(dotColor), _dot(dotColor)],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(dotColor), _dot(dotColor)],
        ),
      ],
    );
  }

  static Widget _dot(Color dotColor) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

