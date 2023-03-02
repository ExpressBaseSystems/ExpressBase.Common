namespace ExpressBase.Common
{
    public enum ImageTypes
    {
        jpg = 1,
        jpeg = 2,
        png = 3,
        svg = 4,
        gif = 5,
        bmp = 6,
    }

    public enum ImageQuality
    {
        original = 0,
        other = 1,
        small = 150,
        medium = 300,
        large = 600
    }

    public enum DPSizes
    {
        micro = 50,
        mini = 150,
    }

    public enum LogoSizes
    {
        small = 50,
        big = 150,
    }

    public enum FileClass
    {
        files = 2,
        image = 1
    }

    public enum ViewerPosition
    {
        FullScreen = 0,
        Left = 1,
        Right = 2
    }
}

