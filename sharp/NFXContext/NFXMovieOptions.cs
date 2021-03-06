﻿using System;
using System.Collections.Generic;
using System.Text;
using ProjectManager.Projects;

namespace NFXContext
{
    class NFXMovieOptions : MovieOptions
    {
        public override string[] TargetPlatforms
        {
            get
            {
                return new string[] {
                    "Flash Player 9",
                    "Flash Player 10"
                };
            }
        }
        public override int Platform
        {
            get { return Version - 9; }
            set { Version = value + 9; }
        }
    }
}
