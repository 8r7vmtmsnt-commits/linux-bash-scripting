#!/bin/bash

echo "Running Security Check"

echo
echo "Logged-in Users:"
who

echo
echo "Failed login attempts:"
lastb

echo
echo "open network ports:"
ss -tuln
